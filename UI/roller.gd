extends HBoxContainer
# Multiplier rarities
var rarities = [
	{"name": "Common", "chance": 70, "multiplier": 0.5},  # Divides reward
	{"name": "Uncommon", "chance": 20, "multiplier": 0.75},  
	{"name": "Rare", "chance": 7, "multiplier": 1.0},  
	{"name": "Epic", "chance": 2, "multiplier": 1.5},  
	{"name": "Legendary", "chance": 1, "multiplier": 2.0}  # Increases reward
]

var texture_rects = []

func _ready():
	generate_skins(15)

func generate_skins(amount, base_value):
	for i in range(amount):
		var skin_box = skin_box_scene.instantiate()
		var rarity = get_random_rarity()

		# Apply rarity properties
		skin_box.get_node("Label").text = rarity.name
		skin_box.get_node("ColorRect").color = rarity.color
		
		# Calculate reward based on multiplier
		var reward = base_value * rarity.multiplier
		skin_box.get_node("RewardLabel").text = "Reward: " + str(reward)

		add_child(skin_box)
