extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$"Create Gauntlet/create-gauntlet-button".connect("pressed", self, "createGauntlet")
	$"Join Gauntlet/add-gauntlet-button".connect("pressed", self, "addGauntlet")
	$"Join Popup".connect("pressed", self, "hidePopup")
	$"Join Popup/Confirm Edit".connect("pressed", self, "addTournament")
	$"Banner/settings-button".connect("pressed", self, "displayMenu")
	$"Settings Popup/ProfileButton".connect("pressed", self, "displayProfile")
	$"Settings Popup/LogoutButton".connect("pressed", self, "displayTitle")
	$"Create Gauntlet/create-gauntlet-button".connect("pressed", self, "displayCreateGauntlet")
	
	$"Join Popup".visible = false
	$"Settings Popup".visible = false
	
func addGauntlet():
	$"Join Popup".visible = true
	
func hidePopup():
	$"Join Popup".visible = false
	
func addTournament():
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
	Globals.lastPage = filename
	get_tree().change_scene("res://TitlePage.tscn")
	
func displayCreateGauntlet():
	Globals.lastPage = filename
	get_tree().change_scene("res://EditChallengePage.tscn")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
