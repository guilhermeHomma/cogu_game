extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var block = preload("res://scene/block_particles.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _explode():
	var instance = block.instance()
	add_child(instance)
	$block_particles.emitting = true
	$tiles.visible = false
	$coll.queue_free()
	var frame_coo = ($tiles.frame_coords)
	var frames = Vector2($tiles.vframes,$tiles.hframes)
	var _scale = 16#por enquanto
	$block_particles/Sprite/AnimationPlayer.play("explode")
	$Timer.start()

func _on_bloco_mouse_entered():
	_explode()
	pass # Replace with function body.


func _on_Timer_timeout():
	queue_free()

