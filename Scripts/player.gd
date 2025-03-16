class_name Player extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
const interact_indicator_prefab: PackedScene = preload("../Prefabs/Interact_Indicator.tscn")

@onready var animated_sprite_2d: AnimatedSprite2D = self.get_node("AnimatedSprite2D")
@onready var interact_area_sensor: Area2D = self.get_node("InteractAreaSensor")
@onready var mining_area_sensor: Area2D = self.get_node("MiningAreaSensor")
@onready var mine_timer: Timer = self.get_node("Timer")

var can_mine: bool = true
var mine_cooldown_time: float = 0.3

var player_damage: int = 10
var speed: int = 400
var jump_speed: int = -600

var inventory = {}

func _ready() -> void:
	mine_timer.timeout.connect(timer_cooldown_finished)
	
	Globals.set_player(self)

func add_to_inventory(block_type: BreakableBlock.bb_types):
	if(block_type not in inventory):
		inventory[block_type] = 1
	else:
		inventory[block_type] += 1

func reduce_from_inventory(block_type: BreakableBlock.bb_types):
	if(block_type in inventory):
		if(inventory[block_type] >= 1):
			inventory[block_type] -= 1
			
func has_in_inventory(block_type: BreakableBlock.bb_types):
	if(block_type in inventory):
		if(inventory[block_type] > 0):
			return true	
	return false

func tryMine() -> bool:
	if(can_mine):
		can_mine = false
		mine_timer.start(mine_cooldown_time)
		print("Success!")
		return true
	else:
		return false

func timer_cooldown_finished():
	can_mine = true

func _physics_process(delta):
	velocity.y += gravity * delta

	if Input.is_action_just_pressed("up") and is_on_floor():
		velocity.y = jump_speed

	
	var leftPressed: bool = Input.is_action_pressed("left")
	var rightPressed: bool = Input.is_action_pressed("right")
	
	if(leftPressed and rightPressed):
		velocity.x = 0
	elif(leftPressed):
		velocity.x = -1 * speed
	elif(rightPressed):
		velocity.x = 1 * speed
	else:
		velocity.x = 0

	move_and_slide()
	
	detect_interact()
	#check_interact()

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
		area_parent.add_child(interact_indicator)
		interact_indicator.global_position = closest_area.global_position + Vector2(0, -10)

#func check_interact():
	#if(Input.is_action_just_pressed("select")):
		#print("Selected object: " + str(closest_area))

func is_in_mining_area(theArea) -> bool:
	var objects_in_area: Array[Area2D] = mining_area_sensor.get_overlapping_areas()
	if(theArea in objects_in_area):
		return true
	else:
		return false

func get_player_damage() -> int:
	return player_damage
