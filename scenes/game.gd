extends Spatial

onready var camera = $Camera
onready var cursor = $Cursor

onready var die = preload("res://scenes/die.tscn")

var mouse_pos = Vector2()
var point = Vector3()
var z_depth = 8
signal fire_click(boolean)
enum States {ACTIVE, INACTIVE}
var current_state = States.ACTIVE
var squares = [[],[],[],[],[]]
var square_groups = ["A_squares", "B_squares", "C_squares", "D_squares", "E_squares"]
var grid = [[],[],[],[],[]]
var grid_groups = ["A_grid", "B_grid", "C_grid", "D_grid", "E_grid"]

func _ready():
#	grid = [[A1,A2,A3,A4,A5],[B1,B2,B3,B4,B5]etc]
	for n in 5:
		var row = get_tree().get_nodes_in_group(square_groups[n])
		for square in row:
			squares[n].append(square)
		row = get_tree().get_nodes_in_group(grid_groups[n])
		for position in row:
			grid[n].append(position)
	for row in squares:
		for index in row:
			print(index)
	for row in grid:
		for index in row:
			print(index)

func _input(event):
	if(event.is_action_pressed("click")):
		emit_signal("fire_click", true)

func _physics_process(delta):
	point = _mouse_track()
	cursor.translation = point

func _mouse_track():
	mouse_pos = get_viewport().get_mouse_position()
	return camera.project_position(mouse_pos, z_depth)
