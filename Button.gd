extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _init():
	self.connect("pressed", self, "_button_pressed")

func _button_pressed():
	if get_parent().get_parent().get_node("Settings").visible == true:
		get_parent().get_parent().get_node("Settings").visible = false
	else:
		get_parent().get_parent().get_node("Settings").visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
