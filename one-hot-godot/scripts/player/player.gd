class_name Player
extends CharacterBody3D

@onready var collision_shape: CollisionShape3D = $CollisionShape3D
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D

@onready var fpsCam: FPSCam = $neck

@onready var wall_left: RayCast3D = $wallLeft
@onready var wall_right: RayCast3D = $wallRight
@onready var ceil_check: RayCast3D = $ceilCheck

@export_group("Move Speed")
@export var run_speed: float = 15
@export var crouch_speed: float = 8
@export var  wallrun_speed: float = 20
@export_subgroup("Interpolations")
@export var default_lerp: float = 5
@export var acceleration: float = 8
@export var friction: float = 12
@export_group("Mobility")
@export var jump_strength: float = 10
@export var wall_jump_strength: float = 30
@export var air_dash_strength: float = 20
@export var slide_strength: float = 25
@export_group("Timing")
@export var dash_time: float = 0.5
@export var wallrun_time: float = 0.8
@export var coyote_time: float = 0.3

var current_speed: float = 0

func _process(_delta: float) -> void:
	current_speed = Vector2(velocity.x, velocity.z).length()

func get_input_dir() -> Vector2:
	return Input.get_vector(&'left', &'right', &'up', &'down').normalized()

func get_move_dir() -> Vector3:
	return (transform.basis * Vector3(get_input_dir().x, 0, get_input_dir().y)).normalized()

func apply_gravity(delta: float, multipler: float = 1) -> void:
	velocity.y += (get_gravity().y * multipler) * delta

func do_dash(dir: Vector3, strength: float) -> void:
	velocity = dir * strength

func do_move(dir: Vector3, speed: float, amount: float, delta: float) -> void:
	velocity.x = lerpf(velocity.x, dir.x * speed, amount * delta)
	velocity.z = lerpf(velocity.z, dir.z * speed, amount * delta)

func do_crouch(height: float, duration: float = 0.15) -> void:
	var tween: Tween = get_tree().create_tween()
	var shape: CapsuleShape3D = collision_shape.shape
	var mesh_shape: CapsuleMesh = mesh_instance_3d.mesh
	tween.tween_property(shape, ^'height', height, duration)
	tween.tween_property(mesh_shape, ^'height', height, duration)
