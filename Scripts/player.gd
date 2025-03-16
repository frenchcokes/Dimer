class_name Player extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
const interact_indicator_prefab: PackedScene = preload("../Prefabs/Interact_Indicator.tscn")

@onready var animated_sprite_2d: AnimatedSprite2D = self.get_node("AnimatedSprite2D")
@onready var interact_area_sensor: Area2D = self.get_node("InteractAreaSensor")
@onready var mining_area_sensor: Area2D = self.get_node("MiningAreaSensor")
@onready var mine_timer: Timer = self.get_node("Timer")

@onready var walkingAudio: AudioStreamPlayer2D = $Walking
@onready var jumpingAudio: AudioStreamPlayer2D = $Jumping


var can_mine: bool = true
var mine_cooldown_time: float = 0.3

var player_damage: int = 10
var speed: int = 200
var jump_speed: int = -250
var money: float = 0.0
var maxMinedDepth: int = 0

var inventory = {}
var inventoryValue: int = 0

var is_in_ui := false

signal stats_updated(money, inventoryValue, player_damage, maxMinedDepth)

func _ready() -> void:
	mine_timer.timeout.connect(timer_cooldown_finished)
	
	Globals.set_player(self)

func add_to_inventory(block_type: BreakableBlock.bb_types):
	if(block_type not in inventory):
		inventory[block_type] = 1
	else:
		inventory[block_type] += 1
	var block = BreakableBlock.new()
	block.set_block_type(block_type)
	inventoryValue += block.get_value()
	emit_signal("stats_updated", money, inventoryValue, player_damage, maxMinedDepth)
	

func reduce_from_inventory(block_type: BreakableBlock.bb_types):
	if(block_type in inventory):
		if(inventory[block_type] >= 1):
			inventory[block_type] -= 1
	var block = BreakableBlock.new()
	block.set_block_type(block_type)
	inventoryValue -= block.get_value()
	emit_signal("stats_updated", money, inventoryValue, player_damage, maxMinedDepth)
			
func has_in_inventory(block_type: BreakableBlock.bb_types):
	if(block_type in inventory):
		if(inventory[block_type] > 0):
			return true
	return false

func tryMine() -> bool:
	if(can_mine):
		can_mine = false
		mine_timer.start(mine_cooldown_time)
		return true
	else:
		return false

func timer_cooldown_finished():
	can_mine = true

var bSoundChanged := false
var grassWalkingSound = load("res://Assets/Audio/player_walking.mp3")
var currentWalkingStream = grassWalkingSound
var woodWalkingSound = [
		preload("res://Assets/Audio/kenney_impact-sounds/Audio/footstep_wood_000.ogg"),
		preload("res://Assets/Audio/kenney_impact-sounds/Audio/footstep_wood_001.ogg"),
		preload("res://Assets/Audio/kenney_impact-sounds/Audio/footstep_wood_002.ogg"),
		preload("res://Assets/Audio/kenney_impact-sounds/Audio/footstep_wood_003.ogg"),
		preload("res://Assets/Audio/kenney_impact-sounds/Audio/footstep_wood_004.ogg")
	]
	
func _physics_process(delta):	
	if global_position.x >= 960 and not bSoundChanged:
		walkingAudio.stop()
		var index = randi_range(0, woodWalkingSound.size()-1)
		currentWalkingStream = woodWalkingSound[index]
		bSoundChanged = true
		print("Changing to wood sound")
	elif global_position.x < 960 and bSoundChanged:
		walkingAudio.stop()
		currentWalkingStream = grassWalkingSound
		bSoundChanged = false
	
	if is_in_ui:
		return
		
	velocity.y += gravity * delta

	if Input.is_action_just_pressed("up") and is_on_floor():
		velocity.y = jump_speed
		jumpingAudio.play()
	
	var leftPressed: bool = Input.is_action_pressed("left")
	var rightPressed: bool = Input.is_action_pressed("right")
	
	if(leftPressed and rightPressed):
		velocity.x = 0
		animated_sprite_2d.play("default")
		walkingAudio.stop()
	elif(leftPressed):
		velocity.x = -1 * speed
		animated_sprite_2d.flip_h = true
		animated_sprite_2d.play("walk")
		play_walking_audio(currentWalkingStream, delta)
	elif(rightPressed):
		velocity.x = 1 * speed
		animated_sprite_2d.flip_h = false
		animated_sprite_2d.play("walk")
		play_walking_audio(currentWalkingStream, delta)
	else:
		velocity.x = 0
		animated_sprite_2d.play("default")
		walkingAudio.stop()

	move_and_slide()
	
	detect_interact()
	check_interact()

var step_timer = 0.0
var step_interval = 0.35
func play_walking_audio(stream, delta):
	if is_on_floor():
		step_timer += delta
		if !walkingAudio.playing and stream == grassWalkingSound:
			walkingAudio.stream = stream
			walkingAudio.play()
		elif !walkingAudio.playing and stream != grassWalkingSound and step_timer >= step_interval:
			walkingAudio.stream = stream
			walkingAudio.play()
			step_timer = 0.0
			

var closest_area: Area2D = null
var smallest_distance: float = -1
var interact_indicator: Node2D = null
func detect_interact():
	var overlapping_areas: Array[Area2D] = interact_area_sensor.get_overlapping_areas()
	
	closest_area = null
	smallest_distance = -1
	
	if(interact_indicator):
		interact_indicator.queue_free()
	
	for area in overlapping_areas:
		var test_smallest_distance: float = self.global_position.distance_to(area.global_position)
		if(closest_area == null):
			closest_area = area
			smallest_distance = test_smallest_distance
		elif(test_smallest_distance < smallest_distance):
			closest_area = area
			smallest_distance = test_smallest_distance
			
	if(closest_area):
		var area_parent = closest_area.get_parent()
		interact_indicator = interact_indicator_prefab.instantiate()
		if(closest_area is interactable2):
			interact_indicator.get_node("Label").text = closest_area.get_display_text()
		else:
			interact_indicator.get_node("Label").text = ""
		area_parent.add_child(interact_indicator)
		interact_indicator.global_position = closest_area.global_position + Vector2(0, -10)

func check_interact():
	if(Input.is_action_just_pressed("select") and closest_area):
		if(closest_area is interactable2):
			closest_area.interacted_with()

func is_in_mining_area(theArea) -> bool:
	var objects_in_area: Array[Area2D] = mining_area_sensor.get_overlapping_areas()
	if(theArea in objects_in_area):
		return true
	else:
		return false

func get_player_damage() -> int:
	return player_damage
	
func set_player_damage(damageIncrement: int) -> void:
	self.player_damage += damageIncrement
	emit_signal("stats_updated", money, inventoryValue, player_damage, maxMinedDepth)
	
func set_player_money(money: float) -> void:
	self.money = money
	emit_signal("stats_updated", money, inventoryValue, player_damage, maxMinedDepth)
	
func clear_player_inventory() -> void:
	self.inventory.clear()
	self.inventoryValue = 0.0
	emit_signal("stats_updated", money, inventoryValue, player_damage, maxMinedDepth)
	

func get_player_money() -> int:
	return self.money
	
func get_player_inventory_value() -> int:
	return self.inventoryValue
	
func set_player_maxMinedDepth(depth: int) -> void:
	if maxMinedDepth < depth:
		maxMinedDepth = depth
	emit_signal("stats_updated", money, inventoryValue, player_damage, maxMinedDepth)
	return
		
