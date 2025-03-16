class_name GameManager extends Node

@onready var night_time_spawn_point: Node2D = get_node("NightTimeSpawnPoint")

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

func start_day_timer():
	day_timer.start(day_duration)

func end_day():
	Globals.get_player().global_position = night_time_spawn_point.global_position

func start_mine():
	start_day_timer()
	Globals.get_player().global_position = Vector2(0, -30)
