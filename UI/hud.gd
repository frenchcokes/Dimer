extends Control
@onready var hud: Control = $"."
@onready var money_counter: Label = $VBoxContainer/MoneyCounter
@onready var inventory_counter: Label = $VBoxContainer/InventoryCounter
@onready var mining_speed: Label = $VBoxContainer/MiningSpeed
@onready var day_countdown: Label = $VBoxContainer2/DayCountdown
@onready var max_depth_reached: Label = $VBoxContainer/MaxDepthReached
@onready var notify_label: Label = self.get_node("NotifyLabel")

var connected_to_manager = false

func _ready() -> void:
	var player = get_tree().current_scene.find_child("Player", true, false) as Player # Assuming the Player is in a group
	if not player:
		print("Failed to find player.")
	player.connect("stats_updated", Callable(self, "_on_stats_updated"))
	money_counter.text = "Money: " + str(player.get_player_money())
	inventory_counter.text = "Inventory Value: " + str(player.get_player_inventory_value())
	mining_speed.text = "Mining Speed: " + str(player.get_player_damage())
	max_depth_reached.text = "Max Depth Reached: " + str(player.maxMinedDepth)
	Globals.set_hud(self)

func _process(_delta: float) -> void:
	if(!connected_to_manager):
		if(Globals.get_game_manager()):
			Globals.get_game_manager().timer_display.connect(countdown_updated)
			connected_to_manager = true
	

func _on_stats_updated(money, inventoryValue, player_damage, maxMinedDepth):
	money_counter.text = "Money: " + str(money)
	inventory_counter.text = "Inventory Value: " + str(inventoryValue)
	mining_speed.text = "Mining Speed: " + str(player_damage) 
	max_depth_reached.text = "Max Depth Reached: " + str(maxMinedDepth)

func countdown_updated(display: String):
	if(day_countdown):
		day_countdown.text = display

func showMessage(the_message: String = "Something has changed at home!"):
	notify_label.text = the_message
	await get_tree().create_timer(2).timeout
	notify_label.text = ""
