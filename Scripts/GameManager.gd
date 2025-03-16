class_name GameManager extends Node

@onready var day_countdown_label: Label = get_node("Player/DayCountdown")
@onready var night_time_spawn_point: Node2D = get_node("NightTimeSpawnPoint")

var day_timer: Timer
var day_duration: float = 10
var game_state = 0

func _ready() -> void:
	day_timer = Timer.new()
	self.add_child(day_timer)
	day_timer.timeout.connect(end_day)
	day_timer.one_shot = true
	Globals.set_game_manager(self)
	
	start_day_timer()

func _process(_delta: float) -> void:
	day_countdown_label.text = str(int(round(day_timer.time_left)))
	if(day_timer.is_stopped()):
		day_countdown_label.text = "Night Time"

func start_day_timer():
	day_timer.start(day_duration)

func end_day():
	Globals.get_player().global_position = night_time_spawn_point.global_position

func start_mine():
	start_day_timer()
	Globals.get_player().global_position = Vector2(0, -30)
