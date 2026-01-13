extends Node3D
class_name CameraRig

@onready var yaw_pivot: Node3D = $ThirdPersonYawPivot
@onready var third_person_spring_arm: SpringArm3D = $ThirdPersonYawPivot/ThirdPersonSpringArmPivot/SpringArm3D
@onready var third_person_camera: Camera3D = $ThirdPersonYawPivot/ThirdPersonSpringArmPivot/ThirdPersonCamera
@onready var first_person_camera: Camera3D = $FirstPersonPivot/FirstPersonCamera
@export var target: Node3D #Player

func _ready() -> void:
	#Avoid inheriting player's rotations
	top_level = true

func _process(delta: float) -> void:
	global_position = target.global_position

func get_third_person_yaw() -> float:
	return yaw_pivot.global_rotation.y

func rotate_yaw(amount: float) -> void:
	yaw_pivot.rotate_y(amount)
