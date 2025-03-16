extends CenterContainer

@onready var multiplier_label: Label = $PanelContainer/VBoxContainer/MultiplierLabel
@onready var roll_button: Button = $PanelContainer/VBoxContainer/RollButton

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

func _on_roll_button_pressed() -> void:
	var value = rng.randi_range(1, 100)
	multiplier_label.text = "Rolling.."
	await get_tree().create_timer(2).timeout
	if value in range(1, 70):
		multiplier_label.text = str(rarities[0]["multiplier"]) + "x"
	elif value in range(70,90):
		multiplier_label.text = str(rarities[1]["multiplier"]) + "x"
	elif value in range(90, 97):
		multiplier_label.text = str(rarities[2]["multiplier"]) + "x"
	elif value in range(97,99):
		multiplier_label.text = str(rarities[3]["multiplier"]) + "x"
	elif value in range(99,101):
		multiplier_label.text = str(rarities[4]["multiplier"]) + "x"
	await get_tree().create_timer(1).timeout

func _on_exit_button_pressed() -> void:
	hide()
