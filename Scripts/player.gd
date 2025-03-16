extends CharacterBody2D

class_name Player

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
const interact_indicator_prefab: PackedScene = preload("../Prefabs/Interact_Indicator.tscn")

var speed = 400
var jump_speed = -600

var animated_sprite_2d: AnimatedSprite2D
var interact_area_sensor: Area2D

func _ready() -> void:
	animated_sprite_2d = self.get_node("AnimatedSprite2D")
	interact_area_sensor = self.get_node("InteractAreaSensor")

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
	check_interact()

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

func check_interact():
	if(Input.is_action_just_pressed("select")):
		print("Selected object: " + str(closest_area))
