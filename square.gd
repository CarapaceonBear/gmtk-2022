extends Area

onready var temp = $MeshInstance

var cursed = false

func _ready():
	temp.visible = false

func _process(delta):
	if (cursed):
		activate(true)
	else:
		activate(false)

func activate(value):
	temp.visible = value


func _on_Square_body_entered(body):
	if (body.is_in_group("cursor")):
		cursed = true


func _on_Square_body_exited(body):
	if (body.is_in_group("cursor")):
		cursed = false
