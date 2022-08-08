-- Add a new hero (unit)
local bishop = createHero{
  name = "bishop",
  classes = {"healer","enchanter","sorcerer"},
  tier = 3,
  description = "[fg]Heal [yellow]20% [fg]of a unit's [green]max health [fg]in an area around this unit."
}


-- This function creates the data needed to display the level three effect in the shop (NOTE: it does not add *any* functionality to the unit)
bishop:setLevelThree(Types.LevelThree{
  name = "Resurrect",
  description = "Once per arena, immediately revive a fallen unit.",
  color = green,
  hero = bishop
})

-- This function is called when the player enters the arena
function bishop:init(player)
  self.hasResurrected = false
  self.act_cooldown = 5
  self.use_attack_speed = false

  -- Our level three effect is reviving a dead unit, so we want to stop that when it happens
  -- Event handlers allow us to listen for specific events, and if we want, cancel them!
  -- Since "player" is already a variable, we use nPlayer to distinguish the unit from the event
  if player.level == 3 then addEventHandler("player_die", function(handler, event, nPlayer)
    -- Don't let the bishop revive itself
    if nPlayer == player then return end
    if not self.hasResurrected then
      event.cancelled = true

      -- If the damage would put the unit at negative health, instead set it to 0
      nPlayer.hp = 0

      -- Heal the player to full health
      nPlayer:heal(nPlayer.max_hp)

      -- Create our effects for the revive (copied from the existing resurrection effect)
      heal1:play{pitch = random:float(0.95, 1.05), volume = 0.5}
      buff1:play{pitch = random:float(0.95, 1.05), volume = 0.5}
      for i = 1, random:int(4, 6) do HitParticle{group = main.current.effects, x = nPlayer.x, y = nPlayer.y, color = nPlayer.color} end
      for i = 1, random:int(4, 6) do HitParticle{group = main.current.effects, x = player.x, y = player.y, color = player.color} end

      -- This boolean value probably isn't necessary since we cancel the handler, but better safe than sorry
      self.hasResurrected = true
      handler:cancel()
    end
  end) end
end

-- Since we defined "self.act_cooldown", the modloader will automatically call an "act" function for the hero when it should attack
-- We use this to heal every unit in a radius around the bishop.
-- This function *also* handles automatically repeating sorcerer effects, so the Bishop will heal twice if there are multiple sorcerers!
function bishop:act(player)
  local rs = 15
  -- If we have AOE modification items, then we should check that here
  if player.magnify then rs = rs * player.magnify_area_size_m end

  -- Create a Circle and find all the allied units inside
  local check_circle = Circle(player.x, player.y, rs)
  local units = main.current.main:get_objects_in_shape(check_circle, {Player})

  -- Heal all those units
  for _, unit in ipairs(units) do
    unit:heal(0.2 * unit.max_hp * (player.heal_effect_m or 1))
  end

  -- Render the circle (looks the same as Cryomancer, etc.) at the specified area and remove it after a few moments
  local circle = Shapes.OpenCircle{group = main.current.effects, shape = check_circle, color = green[0], duration = 0.5}
  player.t:every_immediate(0.05, function() circle.hidden = not circle.hidden end, 7, function() circle.dead = true end)

  -- Play a happy little healing noise! :D
  heal1:play{pitch = random:float(0.95, 10.5), volume = 0.5}
end