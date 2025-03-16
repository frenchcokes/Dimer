extends CenterContainer
@onready var replay_button: Button = $PanelContainer/VBoxContainer/ReplayButton
@onready var exit_button: Button = $PanelContainer/VBoxContainer/ExitButton


func _on_replay_button_pressed() -> void:
	get_tree().reload_current_scene()


func _on_exit_button_pressed() -> void:
	get_tree().quit()
