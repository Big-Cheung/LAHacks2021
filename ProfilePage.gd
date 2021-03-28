extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	
	var db = Firebase.Database.get_database_reference(Globals.usersPath + "/" + Globals.userID)
	db.read()
	var text = yield(db,"read_successful")
	Globals.userData = parse_json(text)
	#signal connections
	$"ProfilePicture/Change-icon-button".connect("pressed", self, "showIcons")
	$"ProfileInfo/Username-edit".connect("text_entered", self, "changeName")
	$"ProfileInfo/Bio-edit".connect("text_changed", self, "revealSave")
	$"ProfileInfo/Bio-save".connect("pressed", self, "saveBio")
	$"Iconlist".connect("item_selected", self, "changeIcons")
	$"Background/BackButton".connect("pressed", self, "changeHome")
	
	#default display
	$"Iconlist".visible = false
	$"ProfileInfo/Bio-save".visible = false
	
	#default data
	$"ProfilePicture/Icon-image".texture = load("res://Icons/Sprites/" + String(Globals.userData["icon"]) + ".jpg")
	$"ProfileInfo/Username-edit".text = Globals.userData["name"]
	$"ProfileInfo/Bio-edit".text = Globals.userData["bio"]
	var datetime = OS.get_datetime_from_unix_time(Globals.userData["created"])
	$"ProfileInfo/Account-age-data".text = datetime["month"] + "/" + datetime["day"] + "/" + datetime["year"]
	$"ProfileInfo/Gauntlet-wins-data".text = String(Globals.userData["wins"])
	
	
func showIcons():
	if $"Iconlist".visible == false:
		$"Iconlist".visible = true
	else:
		$"Iconlist".visible = false
		
func changeIcons(index):
	Globals.userData["icon"] = index
	$"ProfilePicture/Icon-image".texture = load("res://Icons/Sprites/" + String(Globals.userData["icon"]) + ".jpg")
	Globals.saveUserToFirebase()

func changeName(newName):
	Globals.userData["name"] = newName
	Globals.saveUserToFirebase()
	
func revealSave():
	$"ProfileInfo/Bio-save".visible = true
	
func saveBio():
	Globals.userData["bio"] = $"ProfileInfo/Bio-edit".text
	$"ProfileInfo/Bio-save".visible = false
	Globals.saveUserToFirebase()
	
func changeHome():
	get_tree().change_scene("res://MainPage.tscn")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
