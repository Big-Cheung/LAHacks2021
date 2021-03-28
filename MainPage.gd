extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$"Join Gauntlet/add-gauntlet-button".connect("pressed", self, "showJoinPopup")
	$"Join Popup".connect("pressed", self, "hideJoinPopup")
	$"Join Popup/Confirm Edit".connect("pressed", self, "attemptJoin")
	
	$"Banner/settings-button".connect("pressed", self, "displayMenu")
	$"Settings Popup/close-popup-button".connect("pressed", self, "displayMenu")
	$"Settings Popup/ProfileButton".connect("pressed", self, "displayProfile")
	$"Settings Popup/LogoutButton".connect("pressed", self, "displayTitle")
	$"Create Gauntlet/create-gauntlet-button".connect("pressed", self, "displayCreateGauntlet")
	
	$"Join Popup".visible = false
	$"Settings Popup".visible = false
	
	$"Active-gauntlets".connect("item_activated",self,"displayGauntlet")
	
	for item in Globals.gauntlets.keys():
		$"Active-gauntlets".add_item(Globals.gauntlets[item].name)
		$"Active-gauntlets".set_item_metadata($"Active-gauntlets".get_item_count()-1,item)
	
func showJoinPopup():
	$"Join Popup".visible = true
	$"Join Popup/Join-error-msg".visible = false
	
func hideJoinPopup():
	$"Join Popup".visible = false
	
func attemptJoin():
	var db = Firebase.Database.get_database_reference(Globals.gauntletsPath + "/" + $"Join Popup/Enter Code".text)
	db.read()
	var text = yield(db,"read_successful")
	if (text == "null") :
		$"Join Popup/Join-error-msg".visible = true
		return

	db.update("playerData/"+Globals.userID,
	{
		"name":Globals.userData.name,
		"score":0
	})
	
	Globals.gauntlets[$"Join Popup/Enter Code".text] = parse_json(text)
	$"Active-gauntlets".add_item(Globals.gauntlets[$"Join Popup/Enter Code".text].name)
	$"Active-gauntlets".set_item_metadata($"Active-gauntlets".get_item_count()-1,$"Join Popup/Enter Code".text)
	
	if not Globals.userData.has("gauntlets"):
		Globals.userData.gauntlets = {}
	Globals.userData.gauntlets[$"Join Popup/Enter Code".text] = 0
	Globals.saveUserToFirebase()
	$"Join Popup".visible = false
	
func displayMenu():
	if $"Settings Popup".visible == false:
		$"Settings Popup".visible = true
	else:
		$"Settings Popup".visible = false
	
func displayProfile():
	Globals.lastPage = filename
	get_tree().change_scene("res://ProfilePage.tscn")
	
func displayTitle():
	Firebase.Auth.logout()
	Globals.userData = Globals.defaultUserData
	Globals.gauntlets = {}
	get_tree().change_scene("res://TitlePage.tscn")
	
func displayCreateGauntlet():
	Globals.lastPage = filename
	get_tree().change_scene("res://EditChallengePage.tscn")

func displayGauntlet(index):
	Globals.lastPage = filename
	Globals.currentGauntlet = $"Active-gauntlets".get_item_metadata(index)
	yield(Globals.loadGauntlet(),"completed")
	get_tree().change_scene("res://GauntletPage.tscn")
