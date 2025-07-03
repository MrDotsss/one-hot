extends PlayerState

func enter(_previous_state_path: String, _data: Dictionary = {}) -> void:
	player.do_crouch(1.0)

func exit() -> void:
	player.do_crouch(2.0)

func handle_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		player.fpsCam.do_look(event)

func update(delta: float) -> void:
	player.fpsCam.do_tilt(-8 * player.get_input_dir().x, delta)

	if not player.is_on_floor():
		emit_signal(&'finished', STATES.AIR)

	if Input.is_action_just_pressed(&'jump'):
		emit_signal(&'finished', STATES.AIR, {jump = player.jump_strength})
	elif not Input.is_action_pressed(&'crouch') and not player.ceil_check.is_colliding():
		emit_signal(&'finished', STATES.IDLE)

func physics_update(delta: float) -> void:
	player.do_move(player.get_move_dir(), player.crouch_speed, player.acceleration, delta)
	player.move_and_slide()
