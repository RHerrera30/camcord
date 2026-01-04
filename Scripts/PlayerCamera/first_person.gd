extends CameraState

const FIRST_PERSON_DISTANCE := 0.0

func enter(spring_arm: SpringArm3D, mesh: Node3D):
	spring_arm.spring_length = FIRST_PERSON_DISTANCE
	mesh.visible = false

func handle_input(event: InputEvent, machine):
	if event.is_action_pressed("toggle_camera_pov"):
		print("Toggling camera to third person")
		machine.change_state(machine.get_node("ThirdPerson"))
