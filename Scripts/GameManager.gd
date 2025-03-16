class_name GameManager extends Node

@onready var night_time_spawn_point: Node2D = get_node("NightTimeSpawnPoint")
@onready var player: Player = get_node("Player")
@onready var wife: interactable2 = get_node("Wife")
@onready var son: interactable2 = get_node("Son")
@onready var daughter: interactable2 = get_node("Daughter")
@onready var wife_sprite: Sprite2D = wife.get_node("Sprite2D")
@onready var son_sprite: Sprite2D = son.get_node("Sprite2D")
@onready var daughter_sprite: Sprite2D = daughter.get_node("Sprite2D")

@onready var dialogue_bubble_prefab: PackedScene = preload("res://Prefabs/dialogue_bubble.tscn")

var day_timer: Timer
var day_duration: float = 10
var game_state = 0

signal timer_display(display_string: String)

func _ready() -> void:
	day_timer = Timer.new()
	self.add_child(day_timer)
	day_timer.timeout.connect(end_day)
	day_timer.one_shot = true
	Globals.set_game_manager(self)
	
	setup_interact_points()
	
	set_home_state(0)
	
	get_node("EvilDealer").set_callable(evil_dealer_conversation)
	get_node("EvilDealer").set_display_text("Press E to start introduction")
	
	start_day_timer()

func setup_interact_points():
	var mine_start_interact = get_node("MineStartInteract")
	mine_start_interact.set_callable(start_mine)
	mine_start_interact.set_display_text("Return to the mines")

func _process(_delta: float) -> void:
	if(day_timer.is_stopped()):
		emit_signal("timer_display", "Night Time")
	else:
		emit_signal("timer_display", "Time Left: " + str(int(round(day_timer.time_left))))
	
	if(Input.is_action_just_pressed("exit")):
		get_tree().quit()
	
	if player.is_in_ui and not day_timer.is_paused():
		pause_day_timer()
	if not player.is_in_ui and day_timer.is_paused():
		resume_day_timer()
	

func start_day_timer():
	day_timer.start(day_duration)

func pause_day_timer():
	day_timer.set_paused(true)
	
func resume_day_timer():
	day_timer.set_paused(false)

func end_day():
	check_change_state()
	Globals.get_player().global_position = night_time_spawn_point.global_position

func check_change_state():
	var player = Globals.get_player()
	match(game_state):
		0:
			if(player.maxMinedDepth > 10):
				set_home_state(1)
			pass

func set_home_state(set_state: int):
	match(set_state):
		0:
			wife.global_position = Vector2(1065, -25)
			wife_sprite.flip_h = true
			wife.set_callable(func(): create_chat_interaction(1, [wife]))
			
			son.global_position = Vector2(956, -24)
			son_sprite.flip_h = true
			son.set_callable(func(): create_chat_interaction(2, [son]))
			
			daughter.global_position = Vector2(898, -24)
			daughter_sprite.flip_h = true
			daughter.set_callable(func(): create_chat_interaction(3, [daughter]))
		1:
			wife.global_position = Vector2(930, -25)
			wife_sprite.flip_h = true
			wife.set_callable(func(): create_chat_interaction(11, [wife]))
			
			son.global_position = Vector2(850, -24)
			son_sprite.flip_h = true
			son.set_callable(func(): create_chat_interaction(12, [son]))
			
			daughter.global_position = Vector2(790, -24)
			daughter_sprite.flip_h = true
			daughter.set_callable(func(): create_chat_interaction(13, [daughter]))
		2:
			pass
	pass

func create_chat_interaction(conversation_number: int, interlocutors: Array[Node2D]):
	var conv_control = get_node("ConversationControl")
	if(conv_control):
		conv_control.conversationNumber = conversation_number
		conv_control.interlocutors = interlocutors
		conv_control.startConversation()

#Interactable callback functions
func start_mine():
	start_day_timer()
	Globals.get_player().global_position = Vector2(0, -30)

func evil_dealer_conversation():
	get_node("ConversationControl").conversationNumber = 0
	get_node("ConversationControl").interlocutors = [get_node("EvilDealer")]
	await get_node("ConversationControl").startConversation()
	while get_node("ConversationControl").dialogueRunning:
		await get_tree().process_frame
	get_node("EvilDealer").queue_free()
	var shop_idea = load("res://Scenes/shop.tscn")
	var shop_instance = shop_idea.instantiate()
	shop_instance.position = Vector2i(-145,-29)
	add_child(shop_instance)
