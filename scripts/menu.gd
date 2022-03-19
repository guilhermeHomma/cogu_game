extends Control

onready var stage = preload("res://scene/world.tscn")
onready var player = preload("res://scene/player.tscn")

var _scene
func _on_singleplayer_pressed() -> void:

	var stg = stage.instance()
	var _player = null
	Networking.Criar()
	get_parent().call_deferred("add_child", stg)
	_player = player.instance()
	stg.call_deferred("add_child", _player)
	_player.position = Vector2(-200,-470)

	queue_free()
	pass

func _on_multiplayer_pressed() -> void:
	_scene = get_tree().change_scene("res://scene/menu_multiplayer.tscn")

