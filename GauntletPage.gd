extends Control



func _ready():
	loadGauntlet()
	
	$Container/Submit.connect("pressed",self,"showPopup")
	$Submit/EscapePanel.connect("pressed",self,"hidePopup")
	$Submit.visible = false
	$"Container/JoinCode/Join-code-info".text = String(Globals.gauntletData["id"])


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
	
