extends Node

var player_ref
var game_manager

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
