extends Node3D

@export var mouse_sensibility: float = 0.005

@onready var spring_arm := $SpringArm3D
var zoomin_limit = 2
var zoomout_limit = 7

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		#wrapf and clamp limit range of rotation
		rotation.y -= event.relative.x * mouse_sensibility
		rotation.y = wrapf(rotation.y, 0.0, TAU)
	
		rotation.x -= event.relative.y * mouse_sensibility
		rotation.x = clamp(rotation.x, -PI/2, PI/4)
		
	#camera zoom in/out
	if event.is_action_pressed("wheel_up"):
		if(spring_arm.spring_length > zoomin_limit):
			spring_arm.spring_length -= 1
	if event.is_action_pressed("wheel_down"):
		if(spring_arm.spring_length < zoomout_limit):
			spring_arm.spring_length += 1
	
	#unlock mouse for menus
	if event.is_action_pressed("toggle_mouse_capture"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
