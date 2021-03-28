extends Node


var gauntletsPath = "_root/gauntlets"
var usersPath = "_root/users"
var lastPage = "res://Base.tscn"

var userID = ""
var currentGauntlet = ""

var gauntlets = {}

var gauntletData = {
	"id":currentGauntlet,
	"name":"some name",
	"owner":userID,
	"playerData":{},
	"eventData":{},
	"submissions":{}
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
	"gauntlets":{}
}

var defaultUserData = {
	"id":"",
	"name":"username",
	"icon":0,
	"bio":"hello world",
	"created":"",
	"wins":0,
	"gauntlets":{}
}


func goBack():
	get_tree().change_scene(String(lastPage))

func saveUserToFirebase():
	var dbREF = Firebase.Database.get_database_reference(Globals.usersPath + "/" + Globals.userID)
	dbREF.put(userData)

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
