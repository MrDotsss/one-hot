extends PlayerState

var dir: float = 0

func enter(previous_state_path: String, _data: Dictionary = {}) -> void:
	player.do_crouch(1.0)
	dir = player.get_input_dir().x
	if previous_state_path == STATES.AIR:
		player.do_dash(player.get_move_dir(), player.air_dash_strength)
	else:
		player.do_dash(player.get_move_dir(), player.slide_strength)

	await get_tree().create_timer(player.dash_time).timeout
	emit_signal(&'finished', STATES.CROUCH)

func exit() -> void:
	player.do_crouch(2.0)

func handle_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		player.fpsCam.do_look(event)

func update(delta: float) -> void:
	player.fpsCam.do_tilt(-8 * dir, delta)

	if Input.is_action_just_pressed(&'jump') and player.is_on_floor():
		emit_signal(&'finished', STATES.AIR, {jump = player.jump_strength})
	elif Input.is_action_just_released(&"crouch") and not player.is_on_floor():
		emit_signal(&'finished', STATES.AIR)

func physics_update(delta: float) -> void:
	player.apply_gravity(delta, 0.2)
	player.move_and_slide()
