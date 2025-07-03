extends PlayerState

func enter(_previous_state_path: String, data: Dictionary = {}) -> void:
	if data.has("jump"):
		player.do_dash(Vector3.UP, data.jump)

func exit() -> void:
	pass

func handle_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		player.fpsCam.do_look(event)

func update(delta: float) -> void:
	player.fpsCam.do_tilt(-4 * player.get_input_dir().x, delta)

	if player.is_on_floor():
		emit_signal(&'finished', STATES.IDLE)
	elif (player.wall_left.is_colliding() || player.wall_right.is_colliding()):
		if player.get_input_dir().y < 0:
			emit_signal(&'finished', STATES.WALLRUN)
	elif Input.is_action_just_pressed(&'crouch') and player.get_input_dir().length() != 0:
		emit_signal(&'finished', STATES.DASH)

func physics_update(delta: float) -> void:
	player.do_move(player.get_move_dir(), player.run_speed, player.acceleration / 2, delta)
	player.apply_gravity(delta)
	player.move_and_slide()
