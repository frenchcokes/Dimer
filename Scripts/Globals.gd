extends Node


var player_ref
var game_manager
var pause_menu = preload("res://UI/pausescreen.tscn")
var pause_menu_instance = null

func get_player() -> Player:
	if(player_ref):
		return player_ref
	else:
		print("No player found! This is in Globals.gd.")
		return null

func set_player(the_player: Player):
	player_ref = the_player

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
