extends CenterContainer

@onready var multiplier_label: Label = $PanelContainer/VBoxContainer/MultiplierLabel
@onready var roll_button: Button = $PanelContainer/VBoxContainer/RollButton
@onready var line_edit: LineEdit = $PanelContainer/VBoxContainer/LineEdit
@onready var player: Player

var coin = ["heads", "tails"]

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
	var input = line_edit.text
	if not input or input.to_lower() not in coin:
		line_edit.text = "Please enter in Heads or Tails"
		await get_tree().create_timer(3).timeout
		line_edit.clear()
		return

	# Flip the coin
	var value = rng.randi_range(0, 1)
	multiplier_label.text = "Flipping.."
	await get_tree().create_timer(2).timeout
	multiplier_label.text = coin[value]
	await get_tree().create_timer(2).timeout
	
	# Display result
	if input.to_lower() != coin[value]:
		multiplier_label.text = "You did not win your upgrade."
	else:
		multiplier_label.text = "You increased your mining speed by 1!"
	
	await get_tree().create_timer(2).timeout
	hide()
	player.is_in_ui = false
		

func _on_exit_button_pressed() -> void:
	hide()
	player.is_in_ui = false
