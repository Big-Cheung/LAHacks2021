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
	
	$"Join Popup".visible = false
	
func addGauntlet():
	$"Join Popup".visible = true
	
func hidePopup():
	$"Join Popup".visible = false
	
func addTournament():
	$"Join Popup".visible = false
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
