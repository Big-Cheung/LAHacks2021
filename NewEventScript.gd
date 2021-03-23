extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("button_up",self,"_onButtonClick")

func _onButtonClick():
	# Create a new item and select it
	$"../EventList".add_item("Blank Event")
	$"../EventList".select($"../EventList".get_item_count() - 1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
