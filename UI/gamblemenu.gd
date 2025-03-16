extends CenterContainer

@onready var multiplier_label: Label = $PanelContainer/VBoxContainer/MultiplierLabel
@onready var roll_button: Button = $PanelContainer/VBoxContainer/RollButton
@onready var player: Player

var rarities = [
	{"name": "Common", "chance": 70, "multiplier": 0.5},  # Divides reward
	{"name": "Uncommon", "chance": 20, "multiplier": 1.0},  
	{"name": "Rare", "chance": 7, "multiplier": 1.25},  
	{"name": "Epic", "chance": 2, "multiplier": 1.5},  
	{"name": "Legendary", "chance": 1, "multiplier": 2.0}  # Increases reward
]

var rng : RandomNumberGenerator

func _ready():
	# Generate rng
	rng = RandomNumberGenerator.new()
	rng.randomize()
	player = get_tree().current_scene.find_child("Player", true, false) as Player
	if not player:
		print("Fatal: Failed to find a valid Player object <shopmenu>")
		return

func _on_roll_button_pressed() -> void:
	if player.get_player_inventory_value() <= 0:
		multiplier_label.text = "Nothing to sell! Come back when you have money to throw away!"
		await get_tree().create_timer(3).timeout
		hide()
		return
	
	var value = rng.randi_range(1, 100)
	multiplier_label.text = "Rolling.."
	await get_tree().create_timer(2).timeout
	var multiplier = 1.0
	
	if value in range(1, 70):
		multiplier = rarities[0]["multiplier"]
	elif value in range(70,90):
		multiplier = rarities[1]["multiplier"]
	elif value in range(90, 97):
		multiplier = rarities[2]["multiplier"]
	elif value in range(97,99):
		multiplier = rarities[3]["multiplier"]
	elif value in range(99,101):
		multiplier = rarities[4]["multiplier"]
		
	multiplier_label.text = str(multiplier) + "x"
	await get_tree().create_timer(2).timeout
	var finalValue = player.get_player_inventory_value() *  multiplier
	multiplier_label.text = "You've received a total of: " + str(finalValue)
	await get_tree().create_timer(2).timeout
	player.set_player_money(player.get_player_money() + finalValue)
	player.clear_player_inventory()
	
	hide()
	player.is_in_ui = false

func _on_exit_button_pressed() -> void:
	hide()
	player.is_in_ui = false
	
