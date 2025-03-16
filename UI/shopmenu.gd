extends CenterContainer

func _on_sell_button_pressed() -> void:
	hide()
	var gamble_scene = load("res://UI/gamblemenu.tscn")
	if gamble_scene == null:
		print("Error: Could not load gamblemenu.tscn")
		return

	var gamble = gamble_scene.instantiate()
	if gamble == null:
		print("Error: Could not instantiate gamblemenu")
		return

	print("Successfully instantiated gamble menu")
	var canvas_layer = get_tree().current_scene.find_child("CanvasLayer", true, false)
	
	if canvas_layer and canvas_layer is CanvasLayer:
		canvas_layer.add_child(gamble)
		gamble.visible = true
		gamble.show()


func _on_exit_button_pressed() -> void:
	hide()
