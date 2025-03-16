extends Node

@onready var bubble = $DialogueBubble
@onready var skippable = true
@onready var skipping = false

func _ready():
	var conversationNumber: int = 0
	var interlocutors: Array[Node] = []
	
	var player = get_node("../Player")
	while (player == null):
		await get_tree().process_frame
		player = get_node("../Player")
	interlocutors.append(player)
	
	var json = readJsonFile(0)
	executeDialogues(json, interlocutors)

func readJsonFile(number: int):
	var conversationPath = "res://Dialogues/" + str(number) + ".json"
	var conversationFile = FileAccess.open(conversationPath, FileAccess.READ)
	var jsonString = conversationFile.get_as_text()
	var json = JSON.new()
	var error = json.parse(jsonString)
	if error == OK:
		var data_received = json.data
		if typeof(data_received) == TYPE_ARRAY:
			return data_received
		else:
			print("Unexpected data")
	else:
		print("JSON Parse Error: ", json.get_error_message(), " in ", jsonString, " at line ", json.get_error_line())

func executeDialogues(data: Array, interlocutors: Array[Node]):
	var bubble_idea = preload("res://Prefabs/dialogue_bubble.tscn")
	for i in range(len(data)):
		var bubble_instance = bubble_idea.instantiate()
		bubble_instance.txt = data[i]["text"]
		print(bubble_instance.txt)
		var interlocutor_number = data[i]["interlocutor"]
		bubble_instance.interlocutor = interlocutors[interlocutor_number]
		assert(bubble_instance.interlocutor != null, "The interlocutor failed to load.")
		add_child(bubble_instance)
		
		while (not skipping or not skippable):
			await get_tree().process_frame
		bubble_instance.queue_free()
		skippable = false
	
func _input(event):
	if skippable and (event is InputEventKey) and event.is_pressed():
		if event.keycode == KEY_SPACE:
			skipping = true
	elif not skippable and (event is InputEventKey) and event.is_released():
		if event.keycode == KEY_SPACE:
			skipping = false
			skippable = true
		
