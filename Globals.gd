extends Node

var gauntletsPath = "user://Gauntlets.json"
var usersPath = "user://Players.json"
var lastPage = "res://Base.tscn"

var userID = 0
var userSpriteID = 0
var currentGauntlet = 0

var gauntletData = {
	"id":currentGauntlet,
	"name":"",
	"owner":userID,
	"playerData":{},
	"eventData":[]
}

var playerDataPoint = {
	"name":"Cheung",
	"score":0
}
var userData = {
	"id":0,
	"name":"Cheung",
	"icon":0,
	"bio":"This is a bio",
	"created":0,
	"wins":0,
	"gauntlets":[]
}


func goBack():
	get_tree().change_scene(String(lastPage))


func loadGauntletData():
	var load_data = File.new()
	if not (load_data.file_exists(Globals.gauntletsPath)):
		return false
		
	load_data.open(Globals.gauntletsPath, File.READ)
	var Gauntlets = parse_json(load_data.get_as_text())
	if not (Gauntlets.has(String(Globals.currentGauntlet))):
		load_data.close()
		return false
		
	Globals.gauntletData = Gauntlets[String(Globals.currentGauntlet)]
	load_data.close()
	return true


func _ready():
	pass
