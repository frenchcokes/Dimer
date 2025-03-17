extends Node


var player_ref
var game_manager
var hud
var pause_menu = preload("res://UI/pausescreen.tscn")
var pause_menu_instance = null
var game_over_menu = preload("res://UI/gamblemenu.tscn")
var game_over_menu_instance = null

func get_player() -> Player:
	if(player_ref):
		return player_ref
	else:
		print("No player found! This is in Globals.gd.")
		return null

func set_player(the_player: Player):
	player_ref = the_player

func set_hud(the_hud: Control):
	hud = the_hud

func get_hud():
	return hud

func get_game_manager() -> GameManager:
	if(game_manager):
		return game_manager
	else:
		print("No game manager found! This is in Globals.gd.")
		return null

func set_game_manager(the_game_manager: GameManager):
	game_manager = the_game_manager
	

func display_pause_menu():
	var canvas_layer = get_tree().current_scene.find_child("CanvasLayer", true, false)
	if not canvas_layer:
		print("Canvas layer not found.")
	if not pause_menu_instance:
		pause_menu_instance = pause_menu.instantiate()
		canvas_layer.add_child(pause_menu_instance)
	else:
		pause_menu_instance.show()

func display_game_over():
	var canvas_layer = get_tree().current_scene.find_child("CanvasLayer", true, false)
	if not canvas_layer:
		print("Canvas layer not found.")
	if not game_over_menu_instance:
		game_over_menu_instance = game_over_menu.instantiate()
		canvas_layer.add_child(game_over_menu_instance)
	else:
		game_over_menu_instance.show()
	
