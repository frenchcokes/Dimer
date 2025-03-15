extends StaticBody2D

@onready var interactable: Area2D = $Interactable
@onready var sprite_2d: Sprite2D = $Sprite2D
var ui_opened := false
@onready var shop_ui 

func _ready() -> void:
	interactable.interact = _on_interact
	shop_ui = preload("res://UI/shopmenu.tscn").instantiate()
	var canvas_layer = get_node("../CanvasLayer")
	canvas_layer.add_child(shop_ui)
	shop_ui.hide()

func _on_interact():
	shop_ui.show()
