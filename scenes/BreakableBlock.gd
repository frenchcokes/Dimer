class_name BreakableBlock extends StaticBody2D

@export var tilemap : TileMap
@onready var collision_shape = $CollisionShape2D

var is_mouse_inside = false
var health = 0

func _ready():
	if not tilemap:
		tilemap = get_parent().get_node("TileMap")

func _process(_delta: float) -> void:
	if(Input.is_action_pressed("click") and is_mouse_inside):
		break_block()

func break_block():
	tilemap.set_cell(0, tilemap.local_to_map(global_position))
	queue_free()

func _on_mouse_entered() -> void:
	is_mouse_inside = true

func _on_mouse_exited() -> void:
	is_mouse_inside = false
