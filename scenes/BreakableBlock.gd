extends StaticBody2D
class_name BreakableBlock

@export var tilemap : TileMap

func _ready():
	if not tilemap:
		tilemap = get_parent().get_node("TileMap")
	
func break_block():
	tilemap.set_cell(0, tilemap.local_to_map(global_position))
	queue_free()
