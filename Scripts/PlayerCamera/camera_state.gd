extends Node
class_name CameraState

var camera_rig
var mesh: Node3D

func enter(_camera_rig, _mesh: Node3D) -> void:
	camera_rig = _camera_rig
	mesh = _mesh

func exit() -> void:
	pass

func handle_input(_event: InputEvent, _machine) -> void:
	pass
