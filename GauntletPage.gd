extends Control



func _ready():
	#$"Panel/Container/Leaderboard/ItemList".add_item("Evan Cheung",load("res://Icons/Trophy.png"),false)
	pass

func loadGauntlet():
	var load_data = File.new()
	load_data.open()
