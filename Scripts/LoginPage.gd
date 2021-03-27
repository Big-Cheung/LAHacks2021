extends Control



func _ready():
	$Signin/Signup.connect("pressed",self,"signup")
	$Signin/Signin.connect("pressed",self,"signin")
	Firebase.Auth.connect("login_failed",self,"loginFailed")
	Firebase.Auth.connect("login_succeeded",self,"loginPassed")
	Firebase.Auth.connect("signup_succeeded",self,"loginPassed")
	
	
func signup():
	$Signin/Error.visible = false
	Firebase.Auth.signup_with_email_and_password($Signin/EmailHolder/Email.text, $Signin/PassHolder/Password.text)

func signin():
	$Signin/Error.visible = false
	Firebase.Auth.login_with_email_and_password($Signin/EmailHolder/Email.text, $Signin/PassHolder/Password.text)

func loginPassed(data):
	var user = Firebase.Auth.get_user_data()
	Globals.userID = data.localid
	get_tree().change_scene("res://MainPage.tscn")

func loginFailed(code, msg):
	$Signin/Error.visible = true
	$Signin/Error.text = "Unable to login : " + String(msg)
