extends CenterContainer

@onready var player : Player

func _ready() -> void:
	player = get_tree().current_scene.find_child("Player", true, false) as Player
	if not player:
		print("Fatal: Failed to find a valid Player object <shopmenu>")
		return
	
func _on_sell_button_pressed() -> void:
	hide()
	var gamble_scene = load("res://UI/gamblemenu.tscn")
	if not gamble_scene:
		print("Error: Could not load gamblemenu.tscn")
		return

	var gamble = gamble_scene.instantiate()
	if not gamble:
		print("Error: Could not instantiate gamblemenu")
		return

	var canvas_layer = get_tree().current_scene.find_child("CanvasLayer", true, false)
	
	if canvas_layer and canvas_layer is CanvasLayer:
		canvas_layer.add_child(gamble)
		gamble.visible = true
		gamble.show()


func _on_buy_button_pressed() -> void:
	hide()
	var buy_scene = load("res://UI/buygamblemenu.tscn")
	if not buy_scene:
		print("Error: Could not load buygamblemenu.tscn")
		return
	var buy = buy_scene.instantiate()
	if not buy:
		print("Error: Could not instantiate buygamblemenu")
		return
		
	var canvas_layer = get_tree().current_scene.find_child("CanvasLayer", true, false)
	
	if canvas_layer and canvas_layer is CanvasLayer:
		canvas_layer.add_child(buy)
		buy.visible = true
		buy.show()
	

func _on_intro_button_pressed() -> void:
	hide()
	Globals.game_manager.evil_dealer_intro_sale()

func _on_exit_button_pressed() -> void:
	hide()
	player.is_in_ui = false
