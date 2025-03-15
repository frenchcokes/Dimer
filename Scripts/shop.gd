extends StaticBody2D

@onready var interactable: Area2D = $Interactable
@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	interactable.interact = _on_interact

func _on_interact():
	print("Interacted with shop")
	var shop_ui = preload("res://UI/shopmenu.tscn").instantiate()
	get_tree().current_scene.add_child(shop_ui)
	
