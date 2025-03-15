extends Control

@export var padding: int = 20
@export var distance_to_talker: int = 100
@export var txt: String
@export var max_width = 400
@export var interlocutor: Node
@onready var label = $Label
@onready var background = $NinePatchRect
@onready var is_ready = false

func set_text(text: String):
	label.text = text
	await get_tree().process_frame

func adjust_size():
	
	background.size = label.size + Vector2(2 * padding,2 * padding)
	label.position = background.position + Vector2(padding,padding)
	
	if (label.size.x > max_width):
		label.autowrap_mode = true

	size = background.size

func adjust_pos():
	position.x = interlocutor.position.x - size.x / 2
	position.y = interlocutor.position.y - distance_to_talker - size.y

func typewriter(text: String):
	for i in range(len(text)):
		set_text(text.substr(0,i+1))
		await get_tree().create_timer(.05).timeout

func _process(delta):
	if is_ready:
		adjust_size()
		adjust_pos()

func _ready():
	label.autowrap_mode = false
	is_ready = true
	typewriter(txt)
