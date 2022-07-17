extends Spatial

onready var camera = $Camera
onready var cursor = $Cursor
onready var score_box = $TextBoxB
onready var score_label = $TextBoxB/Viewport/Label
onready var previous_score_label = $TextBoxB2/Viewport/Label
onready var button = $Button
onready var cross = $Cross

onready var die = preload("res://scenes/die.tscn")

var mouse_pos = Vector2()
var point = Vector3()
var z_depth = 8
signal fire_click()
enum States {PLACING, REROLLING, RESOLVING}
var current_state = States.PLACING
var squares = [[],[],[],[],[]]
var square_groups = ["A_squares", "B_squares", "C_squares", "D_squares", "E_squares"]
var grid = [[],[],[],[],[]]
var grid_groups = ["A_grid", "B_grid", "C_grid", "D_grid", "E_grid"]
var score = 0
var previous_score = 0
var click_check = false
var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	for n in 5:
		var row = get_tree().get_nodes_in_group(square_groups[n])
		for square in row:
			squares[n].append(square)
			square.connect("identify", self, "check_squares")
		row = get_tree().get_nodes_in_group(grid_groups[n])
		for position in row:
			grid[n].append(position)
	button.connect("button_clicked", self, "next_game")
	cross.visible = false
	yield(get_tree().create_timer(1.4), "timeout")
	$Sounds/Pencil.play()
	yield(get_tree().create_timer(.7), "timeout")
	$Sounds/Handfull.play()

func _input(event):
	if(current_state == States.PLACING and event.is_action_pressed("click")):
		emit_signal("fire_click")
		current_state = States.REROLLING
		click_check = true
		yield(get_tree().create_timer(2), "timeout")
		if (click_check):
			current_state = States.PLACING

func _physics_process(delta):
	print(current_state)
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
	play_sound()
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
			above.get_children()[0].reroll()
	if (indices[0] != 4):
		var below = grid[indices[0] + 1][indices[1]]
		if (below.get_child_count() != 0):
			rerolling = true
			below.get_children()[0].reroll()
	if (indices[1] != 0):
		var left = grid[indices[0]][indices[1] - 1]
		if (left.get_child_count() != 0):
			rerolling = true
			left.get_children()[0].reroll()
	if (indices[1] != 4):
		var right = grid[indices[0]][indices[1] + 1]
		if (right.get_child_count() != 0):
			rerolling = true
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

func update_score():
	var total = 0
	for row in grid:
		for element in row:
			if (element.get_child_count() != 0):
				total += get_value_from_rotation(element.get_children()[0].tell_rotation())
	score = total
	score_label.text = str(score)
#	score_box.global_scale(Vector3(1, 1, 1.2))
#	yield(get_tree().create_timer(.1), "timeout")
#	score_box.global_scale(Vector3(1, 1, 0.8))

func next_game():
	cross.visible = true
	update_score()
	if (score > previous_score):
		previous_score = score
		previous_score_label.text = str(previous_score)
	yield(get_tree().create_timer(0.5), "timeout")
	reset_game()

func reset_game():
	cross.visible = false
	for row in grid:
		for element in row:
			for n in element.get_children():
				element.remove_child(n)
	for row in squares:
		for element in row:
			element.reset_filled()
	score = 0
	score_label.text = "0"
	current_state = States.PLACING

func play_sound():
	var which_sound = rng.randi_range(1, 5)
	match (which_sound):
		1:
			$Sounds/Sound1.play()
		2:
			$Sounds/Sound2.play()
		3:
			$Sounds/Sound3.play()
		4:
			$Sounds/Sound4.play()
		5:
			$Sounds/Sound5.play()

func _on_FloorArea_body_entered(body):
	if(body.has_method("tell_rotation")):
		click_check = false
		if (current_state == States.REROLLING):
			var grid_position = body.get_parent()
			var indices = check_grid(grid_position)
			current_state = States.RESOLVING
			var rerolling = check_adjacent_in_grid(indices)
			if (rerolling):
				play_sound()
			else:
				current_state = States.PLACING
		yield(get_tree().create_timer(1), "timeout")
		update_score()
		if (current_state == States.RESOLVING):
#			yield(get_tree().create_timer(1), "timeout")
			current_state = States.PLACING
