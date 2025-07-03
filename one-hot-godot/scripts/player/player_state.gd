class_name PlayerState extends State

const STATES: Dictionary = {
	IDLE = "IDLE",
	RUN = "RUN",
	CROUCH = "CROUCH",
	AIR = "AIR",
	DASH = "DASH",
	WALLRUN = "WALLRUN"
}

var player: Player #infer type

func _ready() -> void:
	await owner.ready
	player = owner as Player
	assert(player != null, "The BaseState state type must be used only in the Base scene. It needs the owner to be a Base node.")
