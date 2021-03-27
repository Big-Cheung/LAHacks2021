extends Control
var selected = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	
	#Load data
	loadGauntlet()
	
	#Connect Buttons to their respective functions
	$"Container/NewEvent".connect("pressed", self, "createEvent")
	$"Container/DeleteEvent".connect("pressed", self, "deleteEvent")
	$"Container/EventList".connect("item_selected", self, "showMenu")
	$"Container/EventList".connect("nothing_selected", self, "hideMenu")
	$"Container/Save".connect("pressed",self,"saveGauntlet")
	
	
	#Connect Gauntlet fields to their respective functions
	$"Container/Name".connect("text_changed",self,"changeGauntletName")
	
	#Connect Fields in the Edit Event section to their respective functions
	$"Container/EventMenu/EventName".connect("text_changed",self,"changeText")
	$"Container/EventMenu/Start/Num".connect("value_changed",self,"startValueChanged")
	$"Container/EventMenu/Growth/Num".connect("value_changed",self,"growthValueChanged")
	$"Container/EventMenu/Points/Num".connect("value_changed",self,"pointsValueChanged")
	$"Container/EventMenu/Rounds/Num".connect("value_changed",self,"roundsValueChanged")
	$"Container/EventMenu/Preview/Prefix".connect("text_changed",self,"prefixChanged")
	$"Container/EventMenu/Preview/Suffix".connect("text_changed",self,"suffixChanged")
	
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
	
	#updatePreview()
	checkForEmpty()

func createEvent():
	$"Container/EventList".add_item("Blank Event")
	$"Container/EventList".select($"Container/EventList".get_item_count() - 1)
	Globals.gauntletData.eventData.push_back({
		"name":"Blank Event",
		"start":5,
		"growth":5,
		"points":10,
		"rounds":5,
		"round":1,
		"completed":0,
		"pre":"",
		"suf":""
		})
	$"Container/EventList".emit_signal("item_selected", $"Container/EventList".get_item_count() - 1)
	updatePreview()
	checkForEmpty()
	
func deleteEvent():
	Globals.gauntletData.eventData.remove($"Container/EventList".get_selected_items()[0])
	$"Container/EventList".remove_item($"Container/EventList".get_selected_items()[0])
	$"Container/EventList".unselect_all()
	$"Container/EventList".emit_signal("nothing_selected")
	checkForEmpty()

func showMenu(index):
	selected = index
	$"Container/EventMenu/EventName".text = $"Container/EventList".get_item_text(index)
	$"Container/EventMenu/Start/Num".value = Globals.gauntletData.eventData[index]["start"]
	$"Container/EventMenu/Growth/Num".value = Globals.gauntletData.eventData[index]["growth"]
	$"Container/EventMenu/Points/Num".value = Globals.gauntletData.eventData[index]["points"]
	$"Container/EventMenu/Rounds/Num".value = Globals.gauntletData.eventData[index]["rounds"]
	$"Container/EventMenu".visible = true
	$"Container/DeleteEvent".visible = true

func hideMenu():
	selected = -1
	$"Container/EventList".unselect_all()
	$"Container/DeleteEvent".visible = false
	$"Container/EventMenu".visible = false

func changeGauntletName(text):
	Globals.gauntletData.name = text

func changeText(text):
	$"Container/EventList".set_item_text(selected,text)
	Globals.gauntletData.eventData[selected]["name"] = text

func startValueChanged(newVal):
	Globals.gauntletData.eventData[selected]["start"] = newVal
	$"Container/EventMenu/Start/Num".value = newVal
	updatePreview()

func growthValueChanged(newVal):
	Globals.gauntletData.eventData[selected]["growth"] = newVal
	$"Container/EventMenu/Growth/Num".value = newVal
	updatePreview()
	
func pointsValueChanged(newVal):
	Globals.gauntletData.eventData[selected]["points"] = newVal
	$"Container/EventMenu/Points/Num".value = newVal
	updatePreview()
	
func roundsValueChanged(newVal):
	Globals.gauntletData.eventData[selected]["rounds"] = newVal
	$"Container/EventMenu/Rounds/Num".value = newVal
	updatePreview()
	
func prefixChanged(text):
	Globals.gauntletData.eventData[selected]["pre"] = text
	updatePreview()
	
func suffixChanged(text):
	Globals.gauntletData.eventData[selected]["suf"] = text
	updatePreview()
	
func saveGauntlet():
	#Read the data
	var save_data = File.new()
	var exists = save_data.file_exists(Globals.gauntletsPath)
	save_data.open(Globals.gauntletsPath, File.READ)
	var Gauntlets = {}
	if (exists):
		Gauntlets = parse_json(save_data.get_as_text())
	save_data.close()
	
	#Write the data
	save_data.open(Globals.gauntletsPath, File.WRITE)
	Gauntlets[String(Globals.currentGauntlet)] = Globals.gauntletData
	save_data.store_string(to_json(Gauntlets))
	save_data.close()
	
	#Change back to the previous scene
	Globals.goBack()

func loadGauntlet():
	Globals.loadGauntletData()
	
	#Change on-screen text boxes
	$Container/EventList.clear()
	for item in Globals.gauntletData.eventData:
		$Container/EventList.add_item(item.name)
	
	$Container/Name.text = Globals.gauntletData.name

func checkForEmpty():
	$Container/Save.disabled = ($Container/EventList.get_item_count() < 1)

func updatePreview():
	$Container/EventMenu/Preview/Preview.text = Globals.gauntletData.eventData[selected]["pre"] + " " + String(Globals.gauntletData.eventData[selected].start) + " " + Globals.gauntletData.eventData[selected]["suf"]
