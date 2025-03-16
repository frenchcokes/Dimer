class_name BreakableBlock extends StaticBody2D

@export var tilemap : TileMap
@onready var collision_shape = $CollisionShape2D
@onready var particle_emit = preload("res://Scenes/Particles/mine_particles.tscn")
enum bb_types {BORDER, GRASS, DIRT, STONE, DIAMOND}
@onready var miningAudio: AudioStreamPlayer2D

var is_mouse_inside = false
var is_indestructible = false

var block_type: bb_types
var health = 0
var value = 0 # Sell value

# It sounds like mining lol
var miningStoneSounds = [
	preload("res://Assets/Audio/footstep_concrete_000.mp3"),
	preload("res://Assets/Audio/footstep_concrete_001.mp3"),
	preload("res://Assets/Audio/footstep_concrete_002.mp3"),
	preload("res://Assets/Audio/footstep_concrete_003.mp3"),
	preload("res://Assets/Audio/footstep_concrete_004.mp3")
]
var miningGrassDirtSounds = [
	preload("res://Assets/Audio/footstep_grass_000.mp3"),
	preload("res://Assets/Audio/footstep_grass_001.mp3"),
	preload("res://Assets/Audio/footstep_grass_002.mp3"),
	preload("res://Assets/Audio/footstep_grass_003.mp3")
]

func set_block_type(the_block_type: bb_types) -> void:
	self.block_type = the_block_type
	match(self.block_type):
		"":
			print("ERROR UNSET BLOCK TYPE.")
			pass
		bb_types.BORDER:
			is_indestructible = true
		bb_types.GRASS:
			health = 50
			value = 1
		bb_types.DIRT:
			health = 100
			value = 2
		bb_types.STONE:
			health = 200
			value = 4
		bb_types.DIAMOND:
			health = 400
			value = 100
			print("ERROR UNKNOWN BLOCK TYPE.")
			
func get_block_type() -> bb_types:
	return self.block_type
	
func get_value() -> int:
	return self.value

func _ready():
	if not tilemap:
		tilemap = get_parent().get_node("TileMap")
	
	miningAudio = get_tree().current_scene.find_child("Mining", true, false)
	if not miningAudio:
		print("Failed to find the miningAudio")
	
		
func _process(_delta: float) -> void:
	if(Input.is_action_pressed("click") and is_mouse_inside and not is_indestructible and Globals.get_player().is_in_mining_area(self.get_node("Area2D"))):
		var player = Globals.get_player()
		if(player.tryMine()):
			mine_block(player.get_player_damage())
		# Update player max depth reached
		player.set_player_maxMinedDepth(ceil(tilemap.local_to_map(global_position).y / 2))

func play_mining_audio():
	if !miningAudio.playing:
		miningAudio.stop()
		if block_type == bb_types.GRASS or block_type == bb_types.DIRT:
			var index = randi_range(0, miningGrassDirtSounds.size()-1)
			miningAudio.stream = miningGrassDirtSounds[index]
		else:
			var index = randi_range(0, miningStoneSounds.size()-1)
			miningAudio.stream = miningStoneSounds[index]
		
		miningAudio.seek(miningAudio.get_playback_position() - 0.2)
		miningAudio.play()

func mine_block(damage: int):
	self.health -= damage
	add_child(particle_emit.instantiate())
	play_mining_audio()
	if(self.health <= 0):
		Globals.get_player().add_to_inventory(self.block_type)
		break_block()

func break_block():
	tilemap.set_cell(0, tilemap.local_to_map(global_position) / 2)
	queue_free()

func _on_mouse_entered() -> void:
	is_mouse_inside = true

func _on_mouse_exited() -> void:
	is_mouse_inside = false
