extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _init():
	$Container/NewEvent.connect("pressed", self, "createEvent")

func  createEvent():
	$Container/EventList.add_item("Blank Event")
	$Container/EventList.select($"../EventList".get_item_count() - 1)
	
func deleteEvent():
	
	$Container/EventList.emit_signal("nothing_selected")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
