extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$"ProfilePicture/Change-icon-button".connect("pressed", self, "showIcons")
	$"Iconlist".connect("item_selected", self, "changeIcons")
	$"Iconlist".visible = false
	$"ProfilePicture/Icon-image".texture = load("res://Icons/Sprites/" + String(Globals.userSpriteID) + ".jpg")
	
func showIcons():
	if $"Iconlist".visible == false:
		$"Iconlist".visible = true
	else:
		$"Iconlist".visible = false
		
func changeIcons(index):
	Globals.userSpriteID = index
	$"ProfilePicture/Icon-image".texture = load("res://Icons/Sprites/" + String(Globals.userSpriteID) + ".jpg")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
