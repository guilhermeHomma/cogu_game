extends Control

onready var stage = preload("res://scene/world.tscn")
onready var player = preload("res://scene/player.tscn")

var _scene
func _on_singleplayer_pressed() -> void:

	_scene = get_tree().change_scene("res://scene/world.tscn")
	pass



