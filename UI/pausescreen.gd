extends CenterContainer


func _on_resume_button_pressed() -> void:
	hide()



func _on_exit_button_pressed() -> void:
	get_tree().quit()
