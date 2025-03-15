class_name BreakableBlock extends StaticBody2D

@export var tilemap : TileMap
@onready var collision_shape = $CollisionShape2D

var is_mouse_inside = false
var is_indestructible = false

var block_type: String = ""
var health = 0

func set_block_type(the_block_type: String) -> void:
	self.block_type = the_block_type
	match(self.block_type):
		"":
			print("ERROR UNSET BLOCK TYPE.")
			pass
		"BORDER":
			is_indestructible = true
		"GRASS":
			health = 50
			pass
		"DIRT":
			health = 100
		"STONE":
			health = 200
		"DIAMOND":
			health = 400
		_:
			print("ERROR UNKNOWN BLOCK TYPE.")

func _ready():
	if not tilemap:
		tilemap = get_parent().get_node("TileMap")

func _process(_delta: float) -> void:
	if(Input.is_action_pressed("click") and is_mouse_inside and not is_indestructible and Globals.get_player().is_in_mining_area(self.get_node("Area2D"))):
		var player = Globals.get_player()
		if(player.tryMine()):
			mine_block(player.get_player_damage())

func mine_block(damage: int):
	self.health -= damage
	print("Block hit, health: " + str(health))
	if(self.health <= 0):
		break_block()

func break_block():
	tilemap.set_cell(0, tilemap.local_to_map(global_position))
	queue_free()

func _on_mouse_entered() -> void:
	is_mouse_inside = true

func _on_mouse_exited() -> void:
	is_mouse_inside = false
