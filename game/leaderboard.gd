extends Panel

var highscores = {
	"players": ["Player", "Player", "Player", "Player", "Player"],
	"scores": [0, 0, 0, 0, 0]
}
var return_scene = "res://title_screen/TitleScreen.tscn"

var scoreFromGame = 0
var enableInput = false

func _ready():
	#get_node("VBoxContainer/LineEdit").visible = false
	#get_node("VBoxContainer/LineEditScore").visible = false
	#get_node("VBoxContainer/Button").visible = false
	load_scores()

func save_scores(player_name, player_score):
	# Open a file
	var file = File.new()
	if file.open("user://saved_game.save", File.WRITE) != 0:
    	print("Error opening file")
    	return
	
	for i in range(0, 5):
		if player_score > highscores.scores[i]:
			var j = 4
			while j > i:
				highscores.players[j] = highscores.players[j - 1]
				highscores.scores[j] = highscores.scores[j - 1]
				j = j - 1
			highscores.players[j] = player_name
			highscores.scores[j] = player_score
			break
	
	# Save the dictionary as JSON (or whatever you want, JSON is convenient here because it's built-in)
	# print(highscores["players"])
	# print(highscores["scores"])
	file.store_line(to_json(highscores))
	file.close()
	print("Saved")

func load_scores():
	# Check if there is a saved file
	var file = File.new()
	if  file.file_exists("user://saved_game.save"):
		# Open existing file
		if file.open("user://saved_game.save", File.READ) != 0:
    		print("Error opening file")
    		return

		# Get the data
		var text = file.get_as_text()
		var dict = parse_json(text)
		highscores = dict
		
		#if dict == null:
		#	highscores.players = ["Player", "Player", "Player", "Player", "Player"]
		#	highscores.scores = [0, 0, 0, 0, 0]
	# Then do what you want with the data
	for i in range(0, 5):
		get_node("VBoxContainer/VBoxContainer").get_child(i).get_child(1).set_text(highscores.players[i])
		var player_score = String(highscores.scores[i])
		get_node("VBoxContainer/VBoxContainer").get_child(i).get_child(2).set_text(player_score)

func _on_Button_pressed():
	var player_name = get_node("VBoxContainer/LineEdit").get_text()
	#var player_score = get_node("VBoxContainer/LineEditScore").get_text()
	var player_score = scoreFromGame
	get_node("VBoxContainer/Success").set_text("SUCCESS! " + str(player_name) + " scored " + player_score)
	save_scores(player_name, int(player_score))
	load_scores()

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene(return_scene)

func receiveScore(s):
	scoreFromGame = s
	enableInput = true
	#get_node("VBoxContainer/LineEdit").visible = true
	#get_node("VBoxContainer/LineEditScore").visible = true
	#get_node("VBoxContainer/Button").visible = true
