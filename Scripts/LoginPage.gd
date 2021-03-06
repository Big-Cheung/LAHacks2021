extends Control


var new_user = false

func _ready():
	$Signin/Signup.connect("pressed",self,"signup")
	$Signin/Signin.connect("pressed",self,"signin")
	Firebase.Auth.connect("login_failed",self,"loginFailed")
	Firebase.Auth.connect("login_succeeded",self,"loginPassed")
	Firebase.Auth.connect("signup_succeeded",self,"loginPassed")
	Firebase.Auth.connect("userdata_received",self,"setUserData")
	
	
func signup():
	$Signin/Error.visible = false
	Firebase.Auth.signup_with_email_and_password($Signin/EmailHolder/Email.text, $Signin/PassHolder/Password.text)
	new_user = true

func signin():
	$Signin/Error.visible = false
	Firebase.Auth.login_with_email_and_password($Signin/EmailHolder/Email.text, $Signin/PassHolder/Password.text)

func loginPassed(data):
	var user = Firebase.Auth.get_user_data()
	Globals.userID = data.localid
	

func loginFailed(code, msg):
	$Signin/Error.visible = true
	$Signin/Error.text = "Unable to login : " + String(msg)
	
func setUserData(data):
	Globals.userData.id = Globals.userID
	Globals.userData.created = data.created_at
	if (new_user):
		yield(Globals.saveUserToFirebase(),"completed")
	else:
		yield(Globals.loadUserFromFirebase(),"completed")
	
	yield(Globals.loadUserGauntletData(),"completed")
	
	get_tree().change_scene("res://MainPage.tscn")
