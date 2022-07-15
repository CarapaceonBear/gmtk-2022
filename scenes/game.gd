extends Spatial

onready var camera = $Camera
onready var cursor = $Cursor

var mouse_pos = Vector2()
var point = Vector3()
var z_depth = 8

func _ready():
	pass

func _physics_process(delta):
	point = _mouse_track()
	cursor.translation = point

func _mouse_track():
	mouse_pos = get_viewport().get_mouse_position()
	return camera.project_position(mouse_pos, z_depth)
