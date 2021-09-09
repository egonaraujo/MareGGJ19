extends Node2D

# Use between 1 and 2
export var type = 1
var mat = ["res://sprites/material1.png", "res://sprites/material2.png"]

func _ready():
	_update_material()
	pass

func _update_material():
	var spr = get_child(0)
	spr.texture = load(mat[type - 1])