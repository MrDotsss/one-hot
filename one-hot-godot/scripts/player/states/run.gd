extends PlayerState

var coyote_timer: float = 0

func enter(_previous_state_path: String, _data: Dictionary = {}) -> void:
	pass

func exit() -> void:
	coyote_timer = 0

func handle_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		player.fpsCam.do_look(event)

func update(delta: float) -> void:
	player.fpsCam.do_tilt(-6 * player.get_input_dir().x, delta)

	if not player.is_on_floor():
		coyote_timer += delta
		if coyote_timer <= player.coyote_time:
			if Input.is_action_just_pressed(&'jump'):
				emit_signal(&'finished', STATES.AIR, {jump = player.jump_strength})
		else:
			emit_signal(&'finished', STATES.AIR)

	if Input.is_action_pressed(&'jump'):
		emit_signal(&'finished', STATES.AIR, {jump = player.jump_strength})
	elif Input.is_action_pressed(&'crouch'):
		emit_signal(&'finished', STATES.DASH)
	elif player.get_input_dir().length() == 0:
		emit_signal(&'finished', STATES.IDLE)

func physics_update(delta: float) -> void:
	player.do_move(player.get_move_dir(), player.run_speed, player.acceleration, delta)
	player.move_and_slide()
