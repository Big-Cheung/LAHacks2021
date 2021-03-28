extends Control

var currentFeedSelected = -1
var currentActivitySelected = -1

func _ready():
	loadGauntlet()
	
	$Container/Submit.connect("pressed",self,"showPopup")
	$Submit/EscapePanel.connect("pressed",self,"hidePopup")
	$"Container/Feed/Good-button".connect("pressed",self,"upVote")
	$"Container/Feed/Bad-button".connect("pressed",self,"upVote")
	$Container/Feed/List.connect("item_selected", self, "voteFeed")
	$Container/Events/List.connect("item_selected", self, "selectActivity")
	$Container/Events/List.connect("nothing_selected", self, "unselectActivity")
	$"Submit/EscapePanel/SubmitContainer/Text".connect("text_entered", self, "submitLink")
	$"Submit/EscapePanel/SubmitContainer/Submit".connect("pressed", self, "submitLink")
	
	$Submit.visible = false
	$"Container/Feed/Good-button".visible = false
	$"Container/Feed/Bad-button".visible = false
	$"Container/JoinCode/Join-code-info".text = String(Globals.gauntletData["id"])

func voteFeed(index):
	currentFeedSelected = index
	$"Container/Feed/Good-button".visible = true
	$"Container/Feed/Bad-button".visible = true
	
func upVote():
	if currentFeedSelected != -1:
		Globals.upvote($Container/Feed/List.get_item_metadata(currentFeedSelected))
		$Container/Feed/List.remove_item(currentFeedSelected)
		$"Container/Feed/Good-button".visible = false
		$"Container/Feed/Bad-button".visible = false
		yield(Globals.checkSubmissions(),"completed")
		get_tree().reload_current_scene()
		currentFeedSelected = -1
	
	
func downVote():
	if currentFeedSelected != -1:
		$Container/Feed/List.remove_item(currentFeedSelected)
		Globals.downvote($Container/Feed/List.get_item_metadata(currentFeedSelected))
		$"Container/Feed/Good-button".visible = false
		$"Container/Feed/Bad-button".visible = false
		yield(Globals.checkSubmissions(),"completed")
		get_tree().reload_current_scene()
		currentFeedSelected = -1

func selectActivity(index):
	currentActivitySelected = index
	$Container/Submit.visible = true

func unselectActivity():
	currentActivitySelected = -1
	$Container/Events/List.unselect_all()
	$Container/Submit.visible = false

func showPopup():
	if currentActivitySelected != -1:
		$Submit.visible = true

func hidePopup():
	$Submit.visible = false
	
func submitLink():
	var url = $"Submit/EscapePanel/SubmitContainer/Text".text
	var submissionData = {
		"userID": Globals.userID,
		"url": url,
		"event": currentActivitySelected,
		"badVotes":{},
		"goodVotes":{}
	}
	Globals.submission(submissionData)
	$Submit.visible = false
	
func loadGauntlet():
	var minVal = min(Globals.gauntletData.playerData.size(),5)
	var sortedList = []
	for key in Globals.gauntletData.playerData.keys():
		sortedList.push_back([key,Globals.gauntletData.playerData[key].score])
	sortedList.sort_custom(self,"sortByKey")
	for item in range(minVal):
		get_node("Container/Leaderboard/"+String(item+1)+"/Name").text = yield(Globals.getPlayerNameFromID(sortedList[item][0]),"completed")
		get_node("Container/Leaderboard/"+String(item+1)+"/Score").text = String(sortedList[item][1])
		get_node("Container/Leaderboard/"+String(item+1)).visible = true
		if (item == 4):
			$Container/Leaderboard/VSeparator.visible = true
	
	$Container/Name.text = Globals.gauntletData.name
	for event in Globals.gauntletData.eventData:
		$Container/Events/Empty.visible = false
		$Container/Events/List.add_item(event.pre + " " + String(event.start + event.growth * (event["round"]-1)) + " " + event.suf + " for " + String(event.points) + " points each.")
	
	if !Globals.gauntletData.has("submissions"):
		Globals.gauntletData.submissions = {}
		
	for submission in Globals.gauntletData.submissions.keys():
		if (Globals.gauntletData.submissions[submission].has("badVotes")):
			if (Globals.gauntletData.submissions[submission].badVotes.has(Globals.userID)):
				continue
		if (Globals.gauntletData.submissions[submission].has("goodVotes")):
			if (Globals.gauntletData.submissions[submission].goodVotes.has(Globals.userID)):
				continue
		
		if (Globals.gauntletData.submissions[submission].userID == Globals.userID):
			continue
		
		$Container/Feed/Empty.visible = false
		var name = yield(Globals.getPlayerNameFromID(Globals.gauntletData.submissions[submission].userID),"completed")
		$Container/Feed/List.add_item(name + " attempted the " + Globals.gauntletData.eventData[Globals.gauntletData.submissions[submission].event].name + " event.")
		$Container/Feed/List.set_item_metadata($Container/Feed/List.get_item_count()-1,submission)

func sortByKey(a,b):
	return (a[1] > b[1])


	
