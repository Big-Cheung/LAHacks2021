extends Control

var currentFeedSelected

func _ready():
	loadGauntlet()
	
	$Container/Submit.connect("pressed",self,"showPopup")
	$Submit/EscapePanel.connect("pressed",self,"hidePopup")
	$"Container/Feed/Good-button".connect("pressed",self,"upVote")
	$"Container/Feed/Bad-button".connect("pressed",self,"upVote")
	$Container/Feed/List.connect("item_selected", self, "voteFeed")
	
	$Submit.visible = false
	$"Container/Feed/Good-button".visible = false
	$"Container/Feed/Bad-button".visible = false
	$"Container/JoinCode/Join-code-info".text = String(Globals.gauntletData["id"])

func voteFeed(index):
	currentFeedSelected = index
	$"Container/Feed/Good-button".visible = true
	$"Container/Feed/Bad-button".visible = true
	
func upVote():
	$Container/Feed/List.remove_item(currentFeedSelected)
	$"Container/Feed/Good-button".visible = false
	$"Container/Feed/Bad-button".visible = false
	
	
func downVote():
	$Container/Feed/List.remove_item(currentFeedSelected)
	$"Container/Feed/Good-button".visible = false
	$"Container/Feed/Bad-button".visible = false

func loadGauntlet():
	Globals.loadGauntletData()
	
	var minVal = min(Globals.gauntletData.playerData.size(),5)
	var sortedList = []
	for key in Globals.gauntletData.playerData.keys():
		sortedList.push_back([key,Globals.gauntletData.playerData[key].score])
	sortedList.sort_custom(self,"sortByKey")
	for item in range(minVal):
		get_node("Container/Leaderboard/"+String(item)).Name.text = Globals.gauntletData.playerData[sortedList[item][0]].name
		get_node("Container/Leaderboard/"+String(item)).Score.text = sortedList[item][0]
		get_node("Container/Leaderboard/"+String(item)).visible = true
		if (item == 4):
			$Container/Leaderboard/VSeparator.visible = true
	
	$Container/Name.text = Globals.gauntletData.name
	for event in Globals.gauntletData.eventData:
		$Container/Events/Empty.visible = false
		$Submit/EscapePanel/SubmitContainer/Event.add_item(event.name)
		$Container/Events/List.add_item(event.pre + " " + String(event.start + event.growth * (event["round"]-1)) + " " + event.suf + " for " + String(event.points) + " points each.")
	
	for submission in Globals.gauntletData.submissions:
		if (submission.badvotes.has(Globals.userID) or submission.goodvotes.has(Globals.userID)):
			continue
		$Container/Events/Empty.visible = false
		$Container/Events/List.add_item(Globals.gauntletData.playerData[submission.userid].name + " attempted the " + Globals.gauntletData.eventData[submission.event].name + " event.")
	
func sortByKey(a,b):
	return (a[1] > b[1])

func showPopup():
	$Submit.visible = true
	$Submit/EscapePanel/SubmitContainer/FileDialog.popup()

func hidePopup():
	$Submit.visible = false
	$Submit/EscapePanel/SubmitContainer/FileDialog.hide()
	
