extends Button

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _init():
	self.connect("pressed", self, "_button_pressed")

func _button_pressed():
	self.get_parent().visible = false
	get_node("../MainPage").visible = true
	get_node("../MainPage").get_tree().paused = false
	get_tree().paused = true




# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
