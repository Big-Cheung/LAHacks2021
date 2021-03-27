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
	
func showJoinPopup():
	$"Join Popup".visible = true
	$"Join Popup/Join-error-msg".visible = false
	
func hideJoinPopup():
	$"Join Popup".visible = false
	
func attemptJoin():
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
	get_tree().change_scene("res://TitlePage.tscn")
	
func displayCreateGauntlet():
	Globals.lastPage = filename
	get_tree().change_scene("res://EditChallengePage.tscn")
	
