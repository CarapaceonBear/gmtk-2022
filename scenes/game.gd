extends Spatial

onready var camera = $Camera
onready var cursor = $Cursor
onready var score_box = $TextBoxB
onready var score_label = $TextBoxB/Viewport/Label

onready var die = preload("res://scenes/die.tscn")

var mouse_pos = Vector2()
var point = Vector3()
var z_depth = 8
signal fire_click(boolean)
enum States {PLACING, REROLLING, RESOLVING}
var current_state = States.PLACING
var squares = [[],[],[],[],[]]
var square_groups = ["A_squares", "B_squares", "C_squares", "D_squares", "E_squares"]
var grid = [[],[],[],[],[]]
var grid_groups = ["A_grid", "B_grid", "C_grid", "D_grid", "E_grid"]
var score = 0

func _ready():
	for n in 5:
		var row = get_tree().get_nodes_in_group(square_groups[n])
		for square in row:
			squares[n].append(square)
			square.connect("identify", self, "check_squares")
		row = get_tree().get_nodes_in_group(grid_groups[n])
		for position in row:
			grid[n].append(position)

func _input(event):
	if(current_state == States.PLACING and event.is_action_pressed("click")):
		emit_signal("fire_click", true)
		current_state = States.REROLLING

func _physics_process(delta):
	point = _mouse_track()
	cursor.translation = point

func _mouse_track():
	mouse_pos = get_viewport().get_mouse_position()
	return camera.project_position(mouse_pos, z_depth)

func check_squares(name):
	var squares_indices
	var y = 0
	for row in squares:
		var x = 0
		for element in row:
			if (element.name == name):
				squares_indices = [y, x]
			x += 1
		y += 1
	var target_in_grid = grid[squares_indices[0]][squares_indices[1]]
	spawn_die(target_in_grid)

func check_grid(grid_position):
	var grid_indices
	var y = 0
	for row in grid:
		var x = 0
		for element in row:
			if (element == grid_position):
				grid_indices = [y, x]
			x += 1
		y += 1
	return grid_indices

func check_adjacent_in_grid(indices):
	var rerolling = false
	if (indices[0] != 0):
		var above = grid[indices[0] - 1][indices[1]]
		if (above.get_child_count() != 0):
			rerolling = true
			var current_value = get_value_from_rotation(above.get_children()[0].tell_rotation())
			update_score(current_value, false)
			above.get_children()[0].reroll()
	if (indices[0] != 4):
		var below = grid[indices[0] + 1][indices[1]]
		if (below.get_child_count() != 0):
			rerolling = true
			var current_value = get_value_from_rotation(below.get_children()[0].tell_rotation())
			update_score(current_value, false)
			below.get_children()[0].reroll()
	if (indices[1] != 0):
		var left = grid[indices[0]][indices[1] - 1]
		if (left.get_child_count() != 0):
			rerolling = true
			var current_value = get_value_from_rotation(left.get_children()[0].tell_rotation())
			update_score(current_value, false)
			left.get_children()[0].reroll()
	if (indices[1] != 4):
		var right = grid[indices[0]][indices[1] + 1]
		if (right.get_child_count() != 0):
			rerolling = true
			var current_value = get_value_from_rotation(right.get_children()[0].tell_rotation())
			update_score(current_value, false)
			right.get_children()[0].reroll()
	return rerolling


func spawn_die(grid_position):
	var new_die = die.instance()
	grid_position.add_child(new_die)
	new_die.global_transform.origin = grid_position.global_transform.origin

func get_value_from_rotation(rotation):
	var value = 1
	if (rotation.x > 88 and rotation.x < 92):
		value = 2
	elif (rotation.z < -88 and rotation.z > -92):
		value = 3
	elif (rotation.z > 88 and rotation.z < 92):
		value = 4
	elif (rotation.x < -88 and rotation.x > -92):
		value = 5
	elif ((rotation.z > 178 and rotation.z < 182) or (rotation.z < -178 and rotation.z > -182)):
		value = 6
	return (value)

func update_score(value, add):
	if (add):
		score += value
	else:
		score -= value
	score_label.text = str(score)
	score_box.global_scale(Vector3(1, 1, 1.2))
	yield(get_tree().create_timer(.1), "timeout")
	score_box.global_scale(Vector3(1, 1, 0.8))

func _on_FloorArea_body_entered(body):
	if(body.has_method("tell_rotation")):
		if (current_state == States.REROLLING):
			var grid_position = body.get_parent()
			var indices = check_grid(grid_position)
			current_state = States.RESOLVING
			var rerolling = check_adjacent_in_grid(indices)
			if (!rerolling):
				current_state = States.PLACING
		yield(get_tree().create_timer(1), "timeout")
		var die_rotation = body.tell_rotation()
		var value = get_value_from_rotation(die_rotation)
		update_score(value, true)
		if (current_state == States.RESOLVING):
#			yield(get_tree().create_timer(1), "timeout")
			current_state = States.PLACING
