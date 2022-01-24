function PlayerStandard:_start_action_ducking(t)

	t = t or self._player_timer
	self.min_crouch_timer = t + 0.2

	
	if self:_interacting() or self:_on_zipline() then
		return
	end

	self:_interupt_action_running(t)

	self._state_data.ducking = true

	self:_stance_entered()
	self:_update_crosshair_offset()

	local velocity = self._unit:mover():velocity()

	self._unit:kill_mover()
	self:_activate_mover(PlayerStandard.MOVER_DUCK, velocity)
	self._ext_network:send("action_change_pose", 2, self._unit:position())
	self:_upd_attention()
end

function PlayerStandard:_end_action_ducking(t, skip_can_stand_check)

	if not skip_can_stand_check and not self:_can_stand() then
		return
	end

	if t then
	
	else
		managers.chat:_receive_message(managers.chat.GAME, "debug", "Crash prevented: no t", Color(255, 0, 255, 255) / 255)
		t = 999999
	end

	if self.min_crouch_timer then

	else
		managers.chat:_receive_message(managers.chat.GAME, "debug", "Crash prevented: no min timer", Color(255, 0, 255, 255) / 255)
		self.min_crouch_timer = 0
	end

	t = t or self._player_timer

	if t < self.min_crouch_timer then
		return
	end

	self._state_data.ducking = false

	self:_stance_entered()
	self:_update_crosshair_offset()

	local velocity = self._unit:mover():velocity()

	self._unit:kill_mover()
	self:_activate_mover(PlayerStandard.MOVER_STAND, velocity)
	self._ext_network:send("action_change_pose", 1, self._unit:position())
	self:_upd_attention()
end