extends CameraState

const ZOOM_IN := 2.0
const ZOOM_OUT := 7.0
const DEFAULT_DISTANCE := 6.0

var spring_arm: SpringArm3D
var camera: Camera3D

func enter(_camera_rig, _mesh: Node3D):
	super.enter(_camera_rig, _mesh)
	
	spring_arm = camera_rig.third_person_spring_arm
	camera = camera_rig.third_person_camera
	
	camera.current = true
	spring_arm.spring_length = DEFAULT_DISTANCE
	mesh.visible = true

func exit():
	camera.current = false

func handle_input(event: InputEvent, machine):
	if event.is_action_pressed("wheel_up"):
		spring_arm.spring_length = max(spring_arm.spring_length - 1, ZOOM_IN)

	if event.is_action_pressed("wheel_down"):
		spring_arm.spring_length = min(spring_arm.spring_length + 1, ZOOM_OUT)

	if event.is_action_pressed("toggle_camera_pov"):
		print("Toggling camera to first person")
		machine.change_state(machine.get_node("FirstPerson"))
