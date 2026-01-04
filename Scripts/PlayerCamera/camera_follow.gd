extends Camera3D

@export var camera_state: Node

@export var spring_arm: Node3D
@export var lerp_power: float = 1.0

#screenshot function
var screenShotCount = 1

func _ready():
	var dir = DirAccess.open("user://")
	dir.make_dir("screenshots")
	dir = DirAccess.open("user://screenshots")
	
	for n in dir.get_files():
		screenShotCount += 1

func _input(event):
	if event.is_action_pressed("screenshot") and \
	camera_state.isInFirstPerson():
		screenshot()

func screenshot():
	await RenderingServer.frame_post_draw
	
	var viewport = get_viewport()
	var img = viewport.get_texture().get_image()
	img.save_png("user://screenshots/ss"+str(screenShotCount)+".png")
	screenShotCount += 1
	print("Screenshot taken")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = lerp(position, spring_arm.position, delta*lerp_power)
