extends PlayerState


var wall_normal: Vector3 = Vector3.ZERO
var wall_forward: Vector3 = Vector3.ZERO
func enter(_previous_state_path: String, _data: Dictionary = {}) -> void:
	player.velocity.y = 0

	await get_tree().create_timer(player.wallrun_time).timeout
	emit_signal(&'finished', STATES.AIR)

func exit() -> void:
	pass

func handle_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		player.fpsCam.do_look(event)

func update(delta: float) -> void:
	if player.wall_left.is_colliding():
		player.fpsCam.do_tilt(-15, 3, delta)
		wall_normal = player.wall_left.get_collision_normal()
	elif player.wall_right.is_colliding():
		player.fpsCam.do_tilt(15, 3, delta)
		wall_normal = player.wall_right.get_collision_normal()
	else:
		emit_signal(&'finished', STATES.AIR)

	wall_forward = wall_normal.cross(-player.transform.basis.y)
	if (player.transform.basis.z - wall_forward).length() < (player.transform.basis.z - -wall_forward).length():
		wall_forward = -wall_forward
	if (player.wall_left.is_colliding() and player.get_input_dir().x < 0) || (player.wall_right.is_colliding() and player.get_input_dir().x > 0):
		wall_forward = wall_forward + -wall_normal
	if Input.is_action_just_pressed(&'jump'):
		player.do_dash(wall_normal + (player.transform.basis.y * 0.15), player.wall_jump_strength)

	if player.is_on_floor():
		emit_signal(&'finished', STATES.IDLE)



func physics_update(delta: float) -> void:
	player.do_move(wall_forward, player.wallrun_speed, player.acceleration, delta)
	player.apply_gravity(delta, 0.15)
	player.move_and_slide()
