extends Area

onready var temp = $MeshInstance
onready var level = $"../.."

var cursed = false
var filled = false

func _ready():
	temp.visible = false
	level.connect("fire_click", self, "activate")

#func _process(delta):
#	if (cursed):
#		activate(true)
#	else:
#		activate(false)

func activate(value):
	if (cursed and not filled):
		temp.visible = value
		filled = true

func _on_Square_body_entered(body):
	if (body.is_in_group("cursor")):
		cursed = true


func _on_Square_body_exited(body):
	if (body.is_in_group("cursor")):
		cursed = false
