extends Node

var gauntletsPath = "user://Gauntlets.json"
var usersPath = "user://Players.json"
var lastPage = "res://Base.tscn"

var userID = ""
var currentGauntlet = "anb31sa"

var gauntletData = {
	"id":currentGauntlet,
	"name":"some name",
	"owner":userID,
	"playerData":{},
	"eventData":[],
	"submissions":[]
}

var playerDataPoint = {
	"name":"Cheung",
	"score":0
}
var userData = {
	"id":"",
	"name":"username",
	"icon":0,
	"bio":"hello world",
	"created":"",
	"wins":0,
	"gauntlets":[]
}


func goBack():
	get_tree().change_scene(String(lastPage))

func loadUserData():
	var load_data = File.new()
	if not (load_data.file_exists(Globals.usersPath)):
		return false
		
	load_data.open(Globals.usersPath, File.READ)
	var Users = parse_json(load_data.get_as_text())
	if not (Users.has(String(Globals.userID))):
		load_data.close()
		return false
		
	Globals.userData = Users[String(Globals.currentUser)]
	load_data.close()
	return true

func saveUserToFirebase():
	var dbREF = Firebase.Database.get_database_reference(Globals.usersPath + "/" + Globals.userID)
	if (dbREF.get_data() == {}):
		dbREF.push(Globals.userData)
		return
	dbREF.update(Globals.userData)

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

func saveGauntletsToFirebase():
	var dbREF = Firebase.Database.get_database_reference(Globals.gauntletsPath + "/" + Globals.currentGauntlet)
	if (dbREF.get_data() == {}):
		dbREF.push(Globals.gauntletData)
		return
	dbREF.update(Globals.gauntletData)
	
func loadGauntletsFromFirebase():
	var dbREF = Firebase.Database.get_database_reference(Globals.gauntletsPath + "/" + Globals.currentGauntlet)
	var dict = dbREF.get_data()
	Globals.gauntletData = dict

func _ready():
	pass
