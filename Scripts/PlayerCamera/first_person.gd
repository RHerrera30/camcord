extends CameraState

#const FIRST_PERSON_DISTANCE := 0.0
var camera: Camera3D

func enter(_camera_rig, _mesh: Node3D) -> void:
	super.enter(_camera_rig, _mesh)
	camera = camera_rig.first_person_camera
	
	camera.current = true
	mesh.visible = false

func exit():
	camera.current = false
	mesh.visible = true

func handle_input(event: InputEvent, machine):
	if event.is_action_pressed("toggle_camera_pov"):
		print("Toggling camera to third person")
		machine.change_state(machine.get_node("ThirdPerson"))
