extends Control

var scene_path_to_load
var scene_to_load = ["res://GameManager/GameManager.tscn", "res://game/LeaderboardControl.tscn", "res://game/Credits.tscn"]

var index = 0
var btn_play
var btn_leaderboard
var btn_credits
var sky1
var sky2

func _ready():
	btn_play = get_node("Play")
	btn_leaderboard = get_node("Leaderboard")
	btn_credits = get_node("Credits")
	sky1 = get_node("Sky")
	sky2 = get_node("Sky2")

#func _on_Button_pressed(scene_to_load):
#	$FadeIn.show()
#	$FadeIn.fade_in()
#	scene_path_to_load = scene_to_load

func _on_FadeIn_fade_finished():
	$FadeIn.hide()
	get_tree().change_scene(scene_path_to_load)

func _process(delta):
	# Background animation
	sky1.rect_position.x = sky1.rect_position.x + delta * 70
	sky2.rect_position.x = sky2.rect_position.x + delta * 70
	if sky1.rect_position.x > 1024:
		sky1.rect_position.x = sky1.rect_position.x - 1024
	if sky2.rect_position.x > 1024:
		sky2.rect_position.x = sky2.rect_position.x - 1024
	
	# Mouse hover animation
	if btn_play.is_hovered():
		get_node("Pointer").rect_position.y = 0
	elif btn_leaderboard.is_hovered():
		get_node("Pointer").rect_position.y = 36
	elif btn_credits.is_hovered():
		get_node("Pointer").rect_position.y = 72
	
	# Button input
	if Input.is_action_just_pressed("ui_up"):
		if index > 0:
			index = index - 1
			get_node("Pointer").rect_position.y = get_node("Pointer").rect_position.y - 36
	elif Input.is_action_just_pressed("ui_down"):
		if index < 2:
			index = index + 1
			get_node("Pointer").rect_position.y = get_node("Pointer").rect_position.y + 36
	elif Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene(scene_to_load[index])

func _on_Play_pressed():
	get_tree().change_scene(scene_to_load[0])
	get_node("Pointer").rect_position.y = 0

func _on_Leaderboard_pressed():
	get_tree().change_scene(scene_to_load[1])
	get_node("Pointer").rect_position.y = -36

func _on_Credits_pressed():
	get_tree().change_scene(scene_to_load[2])
	get_node("Pointer").rect_position.y = -72
