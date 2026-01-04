extends Node

@onready var camera_rig := $"../CameraRig"
@onready var player_mesh := $"../MeshInstance3D"

var current_state: CameraState

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	change_state($ThirdPerson)

func change_state(new_state: CameraState):
	if current_state:
		current_state.exit()
	
	current_state = new_state
	current_state.enter(camera_rig, player_mesh)
	
func handle_input(event: InputEvent):
	if current_state:
		current_state.handle_input(event, self)
		
func isInFirstPerson() -> bool:
	return current_state == $FirstPerson

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
