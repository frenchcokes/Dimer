extends interactable2

func interacted_with():
	Globals.get_game_manager().start_mine()
