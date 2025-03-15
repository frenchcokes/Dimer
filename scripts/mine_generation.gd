extends Node2D

@export var noise_height_texture : NoiseTexture2D
var noise : Noise

@onready var tilemap : TileMap = $TileMap

# Mine resources
var mine_w : int = 20
var mine_h : int = 100
var source_id = 0
var grass = Vector2i(0, 0)
var dirt = Vector2i(0, 1)
var stones = [Vector2i(8, 0), Vector2i(8, 1), Vector2i(2, 1), Vector2i(3, 1), Vector2i(5, 1)] # Randomly chosen stone
var diamond = Vector2i(6, 2)
var air = Vector2i(3, 3)
var border = Vector2i(1, 2)

# Generation resources
var rng : RandomNumberGenerator

# Blocks
var blocks = []

var tilemap_scale = Vector2i(1, 1)

func _ready():
	# Generate rng
	rng = RandomNumberGenerator.new()
	rng.randomize()
	
	# Set up noise map
	noise_height_texture = NoiseTexture2D.new()
	noise = FastNoiseLite.new()
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.frequency = 0.05
	noise.seed = rng.randi()
	noise_height_texture.noise = noise
	
	tilemap.scale = tilemap_scale
	
	generate_mine()


func generate_mine():
	for y in range(mine_h):
		for x in range(mine_w):
			var noiseValue : float = noise.get_noise_2d(x, y);
			
			# Generate mine border
			if (x == 0 or x == mine_w-1):
				tilemap.set_cell(0, Vector2(x, y), source_id, border)
				generate_breakable_block(x, y)
				continue
			
			# Generate grass layer
			if (y == 0):
				tilemap.set_cell(0, Vector2(x, y), source_id, grass)
				generate_breakable_block(x, y)
				continue
			
			# Generate dirt layer
			if (y < 5):
				tilemap.set_cell(0, Vector2(x, y), source_id, dirt)
				generate_breakable_block(x, y)
				continue
			
			# Generate stone/dirt
			if (abs(noiseValue) >= 0.2):
				# Randomly pick between stone1 and stone2 to set.
				tilemap.set_cell(0, Vector2(x, y), source_id, stones[rng.randi_range(0, 4)])
			elif (noiseValue < 0.0):
				tilemap.set_cell(0, Vector2(x, y))
				continue
			else:
				tilemap.set_cell(0, Vector2(x, y), source_id, dirt)
		
			# Generate diamonds 
			if (randi_range(1,10000000) >= 9999999):
				tilemap.set_cell(0, Vector2(x, y), source_id, diamond)
			
			generate_breakable_block(x, y)
				

func generate_breakable_block(x : int, y : int):
	var block = preload("res://Scenes/breakable_block.tscn").instantiate()
	block.position = tilemap.map_to_local(Vector2i(x,y))
	block.tilemap = tilemap
	add_child(block)
	blocks.append(block)
