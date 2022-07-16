extends Area

onready var level = $"../"

var cursed = false
signal button_clicked()

func _ready():
	visible = false
	level.connect("fire_click", self, "activate")

func activate():
	if (cursed):
		emit_signal("button_clicked")

func _on_Button_body_entered(body):
	cursed = true

func _on_Button_body_exited(body):
	cursed = false
