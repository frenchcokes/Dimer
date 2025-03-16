extends CenterContainer

@onready var player: Player = null

func _ready() -> void:
	player = get_tree().current_scene.find_child("Player", true, false) as Player
	if not player:
		print("Fatal: Failed to find a valid Player object <shopmenu>")
		return

func _on_resume_button_pressed() -> void:
	player.is_in_ui = false
	hide()

func _on_exit_button_pressed() -> void:
	get_tree().quit()
