extends Node2D

func _ready():
	pass
	
func makeVisible(i, index):
	$num.frame = index -1
	$num.visible = false
	$up.visible = false
	$right.visible = false
	$down.visible = false
	$left.visible = false
	if i == 1:
		$up.visible = true
		$num.visible = true
	elif i == 2:
		$right.visible = true
		$num.visible = true
	elif i == 3:
		$down.visible = true
		$num.visible = true
	elif i == 4:
		$left.visible = true
		$num.visible = true
