extends Node2D

# Use 1, 2 or 3
export (int) var lives = 1
# Use 1 or 2
export (int)var type = 1
var boxtype1 = ["res://sprites/BoxType1-0.jpg", "res://sprites/BoxType1-1.jpg", "res://sprites/BoxType1-2.jpg"]
var boxtype2 = ["res://sprites/BoxType2-0.jpg", "res://sprites/BoxType2-1.jpg", "res://sprites/BoxType2-2.jpg"]

var animFrame = 0
var timelapse = 0
export (float) var animSpeed = 1

func _ready():
	updateFrame()
	timelapse = 0
	set_process(true)
	#_update_box()
	pass

func _update_box():
	var spr = get_child(0)
	if type == 1:
		spr.texture = load(boxtype1[lives - 1])
	elif type == 2:
		spr.texture = load(boxtype2[lives - 1])

func _decrease_life(num_lives):
	if lives > 0:
		lives = lives - num_lives
		updateFrame()

func _increase_life(num_lives):
	if lives < 3:
		lives = lives + num_lives
		updateFrame()
		return true
	return false


func _process(delta):
	timelapse += delta
	if timelapse > animSpeed:
		timelapse = 0
		if animFrame == 3 :
			set_process(false)
		animFrame = (animFrame +1) % 3
		updateFrame()
#	if Input.is_action_just_pressed("ui_left"):
#		_decrease_life(1)
#	elif Input.is_action_just_pressed("ui_right"):
#		_increase_life(1)

func updateFrame():
	$Sprite.frame = (lives -1)*3 + animFrame

func dead():
	return lives < 1
