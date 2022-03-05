extends TileMap


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var block = preload("res://scene/bloco.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var cells = get_used_cells()
	for i in cells:
		var instance = block.instance()
		instance.position = map_to_world(Vector2(i.x,i.y))+cell_size/2
		instance.get_node("tiles").frame = get_cell(i.x,i.y)
		set_cell(i.x,i.y,-1)
		if i.y < 0 and i.y > -200:
			add_child(instance)
			
		
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
