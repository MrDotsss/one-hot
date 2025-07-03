class_name FPSCam extends Node3D

@onready var player: Player = $".."
@onready var head: Node3D = $head
@onready var player_cam: Camera3D = $head/playerCam

@export var mouse_sensitivity: Vector2 = Vector2(0.1, 0.1)
@export var lock_cursor: bool = true

func _ready() -> void:
	if lock_cursor: Input.mouse_mode =Input.MOUSE_MODE_CAPTURED

func _process(delta: float) -> void:
	if Input.is_action_pressed(&"aim"):
		do_zoom(15, 10, delta)
		Engine.time_scale = 0.15
	else:
		do_zoom(75, 5, delta)
		Engine.time_scale = 1

func do_look(event: InputEventMouseMotion, limit_h: float = -1, limit_v: float = 89) -> void:
	player.rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity.x))
	if limit_h >= 0:
		player.rotation.y = clampf(player.rotation.y, deg_to_rad(-limit_h), deg_to_rad(limit_h))

	head.rotate_x(deg_to_rad(-event.relative.y * mouse_sensitivity.y))
	head.rotation.x = clampf(head.rotation.x, deg_to_rad(-limit_v), deg_to_rad(limit_v))

func do_zoom(zoom: float, speed: float, delta: float) -> void:
	player_cam.fov = lerp(player_cam.fov, zoom, speed * delta)

func do_tilt(angle: float, delta: float, speed: float = 8) -> void:
	rotation.z = lerp(rotation.z, deg_to_rad(angle), speed * delta)
