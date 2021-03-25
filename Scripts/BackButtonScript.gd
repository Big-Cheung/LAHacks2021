extends Button

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("pressed", self, "button_pressed")

func button_pressed():
	get_tree().change_scene(Globals.last_page);




# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
