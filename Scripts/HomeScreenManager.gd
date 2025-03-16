extends Node

@onready var gameplay_scene: PackedScene = preload("res://Scenes/game.tscn")

func _on_start_pressed() -> void:
	get_tree().change_scene_to_packed(gameplay_scene)


func _on_exit_pressed() -> void:
	get_tree().quit()
