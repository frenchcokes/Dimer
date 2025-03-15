extends StaticBody2D
class_name BreakableBlock

@export var tilemap : TileMap
var xPos = 0.0
var yPos = 0.0

func _ready():
	tilemap = $TileMap
	
func break_block():
	tilemap.set_cell(0, tilemap.local_to_map(global_position))
	queue_free()

func _init(x : int, y : int):
	if (x != null and y != null):
		xPos = x
		yPos = y
	else:
		print("Something went wrong with setting the BreakableBlock world position!")
