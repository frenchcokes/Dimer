extends Node

var player_ref

func get_player() -> Player:
	if(player_ref):
		return player_ref
	else:
		print_tree()
		print("No player found! This is in Globals.gd.")
		return null

func set_player(the_player: Player):
	player_ref = the_player
