class_name interactable2 extends Area2D

var callable: Callable
var display_text: String

func _ready() -> void:
	callable = filler

func interacted_with():
	callable.call()

func set_callable(set_call: Callable):
	callable = set_call

func get_display_text():
	return display_text

func set_display_text(dt: String):
	display_text = dt

func filler():
	print("DEFAULT INTERACTION")
