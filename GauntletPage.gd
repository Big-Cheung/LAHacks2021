extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var user = 10392
# Called when the node enters the scene tree for the first time.
func _ready():
	#$"Panel/Container/Leaderboard/ItemList".add_item("Evan Cheung",load("res://Icons/Trophy.png"),false)
	var data = JSON.parse(JsonSTRING)
	$"Panel/Container/BackButton".text = data.$user.name
	
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
