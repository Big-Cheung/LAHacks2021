extends Node

var gauntletsPath = "user://Gauntlets.json"
var usersPath = "user://Players.json"
var lastPage = "res://Base.tscn"

var userID = 0
var currentGauntlet = 0

var gauntletData = {
	"id":0,
	"name":"default",
	"owner":0,
	"playerData":[],
	"eventData":[]
}


func goBack():
	get_tree().change_scene(String(lastPage))

func _ready():
	pass
