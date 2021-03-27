extends Control



func _ready():
	loadGauntlet()


func loadGauntlet():
	Globals.loadGauntletData()
	
	var minVal = min(Globals.gauntletData.playerData.size(),5)
	var sortedList = []
	for key in Globals.gauntletData.playerData.keys():
		sortedList.push_back([key,Globals.gauntletData.playerData[key].score])
	sortedList.sort_custom(self,"sortByKey")
	for item in range(minVal):
		get_node(String(item)).Name.text = Globals.gauntletData.playerData[sortedList[item][0]].name
		get_node(String(item)).Score.text = sortedList[item][0]
	
	$Container/Name.text = Globals.gauntletData.name
	
	
func sortByKey(a,b):
	return (a[1] > b[1])
	
	
