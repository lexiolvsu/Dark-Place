local spell, super = Class(Spell, "x-slash")

function spell:init()
    super.init(self)

    -- Display name
    self.name = "X-Slash"
    -- Name displayed when cast (optional)
    self.cast_name = "X-SLASH"

    -- Battle description
    self.effect = "Physical\nDamage"
    -- Menu description
    self.description = "Deals large physical damage to 1 enemy."

    -- TP cost
    self.cost = 40

    -- Target mode (ally, party, enemy, enemies, or none)
    self.target = "enemy"

    -- Tags that apply to this spell
    self.tags = {"Damage"}
end

function spell:getCastMessage(user, target)
    return "* "..user.chara:getName().." used "..self:getCastName().."!"
end

function spell:onCast(user, target)
	local damage = math.floor((((user.chara:getStat("attack") * 150) / 20) - 3 * (target.defense)) * 1.3)
    local function finishAnim()
        anim_finished = true
		user:setAnimation("battle/idle")
        end
	local function XSlash(scale_x)
		local cutAnim = Sprite("effects/attack/cut")
		Assets.playSound("snd_scytheburst")
		Assets.playSound("snd_criticalswing", 1.2, 1.3)
		user:setAnimation("battle/attack", finishAnim)
		cutAnim:setOrigin(0.5, 0.5)
		cutAnim:setScale(2.5 * scale_x, 2.5)
		cutAnim:setPosition(target:getRelativePos(target.width/2, target.height/2))
		cutAnim.layer = target.layer + 0.01
		cutAnim:play(1/15, false, function(s) s:remove() end)
		user.parent:addChild(cutAnim)
	end

	Game.battle.timer:after(0.1/2, function()
	XSlash(1)
	target:hurt(damage)
	Game.battle.timer:after(1/2, function()
		XSlash(-1)
		target:hurt(damage)
		Game.battle.timer:after(1/2, function()
		end)
	end)
    -- Code the cast effect here
    -- If you return false, you can call Game.battle:finishAction() to finish the spell
	end)
end

return spell