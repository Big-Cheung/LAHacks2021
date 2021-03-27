extends Control



func _ready():
	$Signin/Signup.connect("pressed",self,"signup")
	$Signin/Signin.connect("pressed",self,"signup")
	Firebase.Auth.connect("login_failed",self,"loginFailed")
	Firebase.Auth.connect("login_succeeded",self,"loginPassed")
	Firebase.Auth.connect("signup_succeeded",self,"loginPassed")
	
	
func signup():
	Firebase.Auth.signup_with_email_and_password($Signin/EmailHolder/Email.text, $Signin/PassHolder/Password.text)

func signin():
	Firebase.Auth.login_with_email_and_password($Signin/EmailHolder/Email.text, $Signin/PassHolder/Password.text)

func loginPassed():
	print(Firebase.Auth.get_user_data())

func loginFailed():
	pass
