#REFERENCES FP CONTROLLER BY RYANBATTLER ON YT
extends CharacterBody3D
#@export var camera: Camera3D
#@onready var camera_sm := $CameraStateMachine

var SPEED
const WALK_SPEED = 5.0
const SPRINT_SPEED = 8.0
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.004

#bob variables (FP only)
const BOB_FREQ = 2.4
const BOB_AMP = 0.08
var t_bob = 0.0


# fov variables (FP only)
const BASE_FOV = 75.0
const FOV_CHANGE = 1.5

var gravity = 9.8

@onready var head = $CameraRig/FirstPersonPivot
@onready var camera = $CameraRig/FirstPersonPivot/FirstPersonCamera
@onready var camera_state_machine = $CameraStateMachine

#FP ONLY
func _unhandled_input(event):
	# Always forward input to camera state machine FIRST
	camera_state_machine.handle_input(event)

	if event is not InputEventMouseMotion:
		return

	var mouse_x = event.relative.x * SENSITIVITY
	var mouse_y = event.relative.y * SENSITIVITY

	if camera_state_machine.isInFirstPerson():
		# FIRST PERSON
		head.rotate_y(-mouse_x)
		camera.rotate_x(-mouse_y)
		camera.rotation.x = clamp(
			camera.rotation.x,
			deg_to_rad(-40),
			deg_to_rad(60)
		)
	else:
		# THIRD PERSON
		camera_state_machine.camera_rig.rotate_yaw(-mouse_x)

#func _unhandled_input(event: InputEvent) -> void:
	#camera_sm.handle_input(event)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

	SPEED = SPRINT_SPEED if Input.is_action_pressed("sprint") else WALK_SPEED

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")

	var direction := Vector3(input_dir.x, 0.0, input_dir.y)

	if camera_state_machine.isInFirstPerson():
		# FIRST PERSON
		direction = head.global_transform.basis * direction
	else:
		# THIRD PERSON
		var cam_yaw = camera_state_machine.camera_rig.get_third_person_yaw()
		direction = direction.rotated(Vector3.UP, cam_yaw)

	direction = direction.normalized()
	
	if not camera_state_machine.isInFirstPerson() and direction.length() > 0.1:
		var target_yaw = atan2(direction.x, direction.z)
		rotation.y = lerp_angle(rotation.y, target_yaw, delta * 10.0)

	if is_on_floor():
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = lerp(velocity.x, 0.0, delta * 7.0)
			velocity.z = lerp(velocity.z, 0.0, delta * 7.0)
	else:
		velocity.x = lerp(velocity.x, direction.x * SPEED, delta * 3.0)
		velocity.z = lerp(velocity.z, direction.z * SPEED, delta * 3.0)

	if camera_state_machine.isInFirstPerson():
		#FIRST PERSON (HEAD BOB)
		t_bob += delta * min(velocity.length(), SPRINT_SPEED) * float(is_on_floor())
		camera.transform.origin = _headbob(t_bob)
	else:
		#THIRD PERSON
		t_bob = 0.0
		camera.transform.origin = Vector3.ZERO

	if camera_state_machine.isInFirstPerson():
		var velocity_clamped = clamp(velocity.length(), 0.5, SPRINT_SPEED * 2)
		var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
		camera.fov = lerp(camera.fov, target_fov, delta * 8.0)
	else:
		camera.fov = lerp(camera.fov, BASE_FOV, delta * 8.0)

	move_and_slide()

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos
