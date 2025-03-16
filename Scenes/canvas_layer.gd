extends CanvasLayer

func _ready() -> void:
	for page in $Control.get_children():
		page.hide()

func show_page(page_name: String):
	for page in $Control.get_children():
		page.hide()
		
	var target_page = $Control.get_node(page_name)
	if target_page:
		target_page.show()
		
		

func _on_sell_button_pressed():
	show_page("GambleMenu")
	print("Sell button pressed")
	
