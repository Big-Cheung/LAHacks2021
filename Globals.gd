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
	var dbREF = Firebase.Database.get_database_reference(usersPath + "/" + userID)
	dbREF.put(userData)
	
func loadUserFromFirebase():
	var db = Firebase.Database.get_database_reference(usersPath + "/" + userID)
	db.read()
	var text = yield(db,"read_successful")
	Globals.userData = parse_json(text)

func loadUserGauntletData():
	loadUserFromFirebase()
	for key in userData.gauntlets.keys():
		var db = Firebase.Database.get_database_reference(gauntletsPath + "/" + key)
		db.read()
		var gauntlet = yield(db,"read_successful")
		gauntlets[key] = parse_json(gauntlet)

func saveGauntletToFirebase():
	var dbREF = Firebase.Database.get_database_reference(gauntletsPath + "/" + currentGauntlet)
	dbREF.put(Globals.gauntletData)

func _ready():
	pass
