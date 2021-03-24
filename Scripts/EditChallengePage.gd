extends Control
var selected = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	
	#Connect Buttons to their respective functions
	$"Container/NewEvent".connect("pressed", self, "createEvent")
	$"Container/EventMenu/DeleteEvent".connect("pressed", self, "deleteEvent")
	$"Container/EventList".connect("item_selected", self, "showMenu")
	$"Container/EventList".connect("nothing_selected", self, "hideMenu")
	
	#Connect Fields in the Edit Event section to their respective functions
	$"Container/EventMenu/EventName".connect("text_entered",self,"changeText")
	$"Container/EventMenu/Start/Num".connect("value_changed",self,"startValueChanged")
	$"Container/EventMenu/Growth/Num".connect("value_changed",self,"growthValueChanged")
	$"Container/EventMenu/Points/Num".connect("value_changed",self,"pointsValueChanged")
	$"Container/EventMenu/Rounds/Num".connect("value_changed",self,"roundsValueChanged")
	
	#Change the font size(since you cant set default fonts)
	$"Container/EventMenu/Start/Num".get_line_edit().add_font_override("font", load("res://Style/Fonts/DefaultFont32pt.tres"))
	$"Container/EventMenu/Points/Num".get_line_edit().add_font_override("font", load("res://Style/Fonts/DefaultFont32pt.tres"))
	$"Container/EventMenu/Growth/Num".get_line_edit().add_font_override("font", load("res://Style/Fonts/DefaultFont32pt.tres"))
	$"Container/EventMenu/Rounds/Num".get_line_edit().add_font_override("font", load("res://Style/Fonts/DefaultFont32pt.tres"))
	
	#Link the values of the sliders and spinboxes
	$"Container/EventMenu/Start/Num".share($"Container/EventMenu/Start/Slider")
	$"Container/EventMenu/Growth/Num".share($"Container/EventMenu/Growth/Slider")
	$"Container/EventMenu/Points/Num".share($"Container/EventMenu/Points/Slider")
	$"Container/EventMenu/Rounds/Num".share($"Container/EventMenu/Rounds/Slider")

func createEvent():
	$"Container/EventList".add_item("Blank Event")
	$"Container/EventList".select($"Container/EventList".get_item_count() - 1)
	Globals.eventData.push_back({"start":5,"growth":5,"points":10,"rounds":5})
	$"Container/EventList".emit_signal("item_selected", $"Container/EventList".get_item_count() - 1)
	
func deleteEvent():
	Globals.eventData.remove($"Container/EventList".get_selected_items()[0])
	$"Container/EventList".remove_item($"Container/EventList".get_selected_items()[0])
	$"Container/EventList".unselect_all()
	$"Container/EventList".emit_signal("nothing_selected")

func showMenu(index):
	selected = index
	$"Container/EventMenu/EventName".text = $"Container/EventList".get_item_text(index)
	$"Container/EventMenu/Start/Num".value = Globals.eventData[index]["start"]
	$"Container/EventMenu/Growth/Num".value = Globals.eventData[index]["growth"]
	$"Container/EventMenu/Points/Num".value = Globals.eventData[index]["points"]
	$"Container/EventMenu/Rounds/Num".value = Globals.eventData[index]["rounds"]
	$"Container/EventMenu".visible = true

func hideMenu():
	selected = -1
	$"Container/EventList".unselect_all()
	$"Container/EventMenu".visible = false


func changeText(text):
	$"Container/EventList".set_item_text(selected,text)
	$"Container/EventMenu/EventName".text = text

func startValueChanged(newVal):
	Globals.eventData[selected]["start"] = newVal
	$"Container/EventMenu/Start/Num".value = newVal

func growthValueChanged(newVal):
	Globals.eventData[selected]["growth"] = newVal
	$"Container/EventMenu/Growth/Num".value = newVal
	
func pointsValueChanged(newVal):
	Globals.eventData[selected]["points"] = newVal
	$"Container/EventMenu/Points/Num".value = newVal
	
func roundsValueChanged(newVal):
	Globals.eventData[selected]["rounds"] = newVal
	$"Container/EventMenu/Rounds/Num".value = newVal

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
