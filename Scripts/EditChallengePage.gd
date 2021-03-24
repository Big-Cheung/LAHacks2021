extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$"Container/NewEvent".connect("pressed", self, "createEvent")
	$"Container/EventMenu/DeleteEvent".connect("pressed", self, "deleteEvent")
	$"Container/EventList".connect("item_selected", self, "showMenu")
	$"Container/EventList".connect("nothing_selected", self, "hideMenu")

func createEvent():
	$"Container/EventList".add_item("Blank Event")
	$"Container/EventList".select($"Container/EventList".get_item_count() - 1)
	$"Container/EventList".emit_signal("item_selected", $"Container/EventList".get_item_count() - 1)
	
func deleteEvent():
	$"Container/EventList".remove_item($"Container/EventList".get_selected_items()[0])
	$"Container/EventList".unselect_all()
	$"Container/EventList".emit_signal("nothing_selected")

func showMenu(index):
	$"Container/EventMenu".visible = true

func hideMenu():
	$"Container/EventMenu".visible = false


	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
