extends Control
@onready var hud: Control = $"."
@onready var money_counter: Label = $VBoxContainer/MoneyCounter
@onready var inventory_counter: Label = $VBoxContainer/InventoryCounter
@onready var mining_speed: Label = $VBoxContainer/MiningSpeed

func _ready() -> void:
	var player = get_tree().current_scene.find_child("Player", true, false)  # Assuming the Player is in a group
	if not player:
		print("Failed to find player.")
	player.connect("stats_updated", Callable(self, "_on_stats_updated"))
	

func _on_stats_updated(money, inventoryValue, player_damage):
	if money and inventoryValue and player_damage:
		money_counter.text = "Money: " + str(money)
		inventory_counter.text = "Inventory Value: " + str(inventoryValue)
		mining_speed.text = "Mining Speed: " + str(player_damage) 
