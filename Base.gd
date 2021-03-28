extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Firebase.Auth.connect("signup_succeeded",self,"pullData")
	Firebase.Auth.login_anonymous()

func pullData(info):
	var db = Firebase.Database.get_database_reference("_root")
	db.connect("read_successful",self,"printData")
	db.read("_root")

func printData(result, response_code, headers, body):
	print(result)
	print(response_code)
	print(headers)
	print(body)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
