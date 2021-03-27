extends Node

var gauntletsPath = "user://Gauntlets.json"
var usersPath = "user://Players.json"
var lastPage = "res://Base.tscn"

var userID = 0
var currentGauntlet = 0

var gauntletData = {
	"id":currentGauntlet,
	"name":"default",
	"owner":userID,
	"playerData":{},
	"eventData":[]
}


func goBack():
	get_tree().change_scene(String(lastPage))

func _ready():
	pass
