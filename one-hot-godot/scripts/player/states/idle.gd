extends PlayerState

func enter(_previous_state_path: String, _data: Dictionary = {}) -> void:
	pass

func exit() -> void:
	pass

func handle_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		player.fpsCam.do_look(event)

func update(delta: float) -> void:
	player.fpsCam.do_tilt(0, delta)

	if not player.is_on_floor():
		emit_signal(&'finished', STATES.AIR)

	if Input.is_action_pressed(&'jump'):
		emit_signal(&'finished', STATES.AIR, {jump = player.jump_strength})
	elif Input.is_action_pressed(&'crouch'):
		emit_signal(&'finished', STATES.CROUCH)
	elif player.get_input_dir().length() != 0:
		emit_signal(&'finished', STATES.RUN)

func physics_update(delta: float) -> void:
	player.do_move(Vector3.ZERO, 0, player.friction, delta)
	player.move_and_slide()
