extends Node3D
class_name CameraRig

@onready var third_person_spring_arm: SpringArm3D = $ThirdPersonSpringArmPivot/SpringArm3D
@onready var third_person_camera: Camera3D = $ThirdPersonSpringArmPivot/ThirdPersonCamera
@onready var first_person_camera: Camera3D = $FirstPersonPivot/FirstPersonCamera
