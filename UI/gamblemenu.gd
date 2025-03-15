extends CenterContainer

@onready var line_edit: LineEdit = $PanelContainer/VBoxContainer/LineEdit
var rng : RandomNumberGenerator

func _ready():
	# Generate rng
	rng = RandomNumberGenerator.new()
	rng.randomize()

func _on_roll_button_pressed() -> void:
	var user_input = line_edit.text
	print(user_input)
	if not user_input.is_valid_int():
		line_edit.text = ""
	elif int(user_input) in range(1, 20):
		print("Rolled: ", rng.randi_range(1, 20))


func _on_exit_button_pressed() -> void:
	hide()
