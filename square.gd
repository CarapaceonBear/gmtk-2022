extends Area

onready var temp = $MeshInstance
onready var level = $"../.."

var cursed = false
var filled = false
signal identify(name)

func _ready():
	temp.visible = false
	level.connect("fire_click", self, "activate")

#func _process(delta):
#	if (cursed):
#		activate(true)
#	else:
#		activate(false)

func activate():
	if (cursed and not filled):
		filled = true
		emit_signal("identify", self.name)

func reset_filled():
	filled = false

func _on_Square_body_entered(body):
	if (body.is_in_group("cursor")):
		cursed = true


func _on_Square_body_exited(body):
	if (body.is_in_group("cursor")):
		cursed = false
