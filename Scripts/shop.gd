extends StaticBody2D

@onready var interactable: Area2D = $Interactable
@onready var sprite_2d: Sprite2D = $Sprite2D
var ui_opened := false
@onready var shop_ui 
@onready var player: Player

func _ready() -> void:
	interactable.interact = _on_interact
	shop_ui = preload("res://UI/shopmenu.tscn").instantiate()
	var canvas_layer = get_node("../CanvasLayer")
	canvas_layer.add_child(shop_ui)
	shop_ui.hide()
	player = get_tree().current_scene.find_child("Player", true, false) as Player
	if not player:
		print("Fatal: Failed to find a valid Player object <shopmenu>")
		return

func _on_interact():
	if player.is_in_ui:
		return
	shop_ui.show()
	player.is_in_ui = true
