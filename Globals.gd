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
	var user = Firebase.Database.get_database_reference(usersPath + "/" + userID + "/gauntlets")
	user.read()
	var userGauntlets = yield(user,"read_successful")
	if userGauntlets == "null":
		return
	
	userGauntlets = parse_json(userGauntlets)
	for key in userGauntlets.keys():
		var db = Firebase.Database.get_database_reference(gauntletsPath + "/" + key)
		db.read()
		var gauntlet = yield(db,"read_successful")
		gauntlets[key] = parse_json(gauntlet)

func loadGauntlet():
	var db = Firebase.Database.get_database_reference(gauntletsPath + "/" + currentGauntlet)
	db.read()
	var text = yield(db,"read_successful")
	gauntletData = parse_json(text)
	
func saveGauntletToFirebase():
	var dbREF = Firebase.Database.get_database_reference(gauntletsPath + "/" + currentGauntlet)
	dbREF.put(Globals.gauntletData)
	
func getPlayerNameFromID(id):
	var db = Firebase.Database.get_database_reference(usersPath + "/" + id)
	db.read()
	var text = yield(db, "read_successful")
	if text == "null":
		return "null"
	var user = parse_json(text)
	return user["name"]

func upvote(key):
	var db = Firebase.Database.get_database_reference(gauntletsPath + "/" + currentGauntlet  + "/submissions/" + key)
	db.update("goodVotes",{userID:0})
	
func downvote(key):
	var db = Firebase.Database.get_database_reference(gauntletsPath + "/" + currentGauntlet  + "/submissions/" + key)
	db.update("badVotes",{userID:0})

func submission(data):
	var db = Firebase.Database.get_database_reference(gauntletsPath + "/" + currentGauntlet  + "/submissions")
	db.push(data)
	
func checkSubmissions():
	yield(loadGauntlet(),"completed")
	var db = Firebase.Database.get_database_reference(gauntletsPath + "/" + currentGauntlet  + "/submissions")
	db.read()
	var text = yield(db,"read_successful")
	var subs = parse_json(text)
	gauntletData.submissions = subs
	for key in subs.keys():
		if not subs[key].has("goodVotes"):
			continue
		if subs[key]["goodVotes"].size() >= floor(gauntletData.playerData.size() / 2):
			var points = (((gauntletData.eventData[subs[key].event].round-1) * gauntletData.eventData[subs[key].event].growth) + gauntletData.eventData[subs[key].event].start) * gauntletData.eventData[subs[key].event].points
			gauntletData.playerData[subs[key].userID].score += points
			gauntletData.eventData[subs[key].event].completed += 1
			subs.erase(key)
			gauntletData.submissions.erase(key)
	
	for event in gauntletData.eventData:
		if event.completed >= floor(gauntletData.playerData.size() * 0.75):
			event.round += 1
			for key in gauntletData.submissions.keys():
				if gauntletData.eventData[gauntletData.submissions[key].event] == event:
					gauntletData.submissions.erase(event)
	
	for event in range(gauntletData.eventData.size()-1,0,-1):
		if gauntletData.eventData[event].completed > gauntletData.eventData[event].rounds:
			gauntletData.eventData.remove(event)
	
	saveGauntletToFirebase()
	

func _ready():
	pass
