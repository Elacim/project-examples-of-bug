extends Area_Generic
class_name Area_Overhead

signal setup_instance(scale, dialogue_text, dialogue_rect_size)

const SceneOverheadDialogue = preload("res://Assets/Clicks/_ClickInstances/Instanced_Overhead_Dialogue.tscn")

# if the dialogue type is overhead, what should it be?
# Cycles through the options (no option for random yet)
export(Array, String, MULTILINE) var overhead_dialogue_text = []

# Should the dialogue cycle through the array or be selected randomly?
#export(bool) var overhead_random_dialogue = false
export(bool) var randomize_dialogue = false

# The scale of the overhead dialogue
export(Vector3) var overhead_dialogue_scale = Vector3(2, 2, 2) setget set_dialogue_scale, get_dialogue_scale

# What is the default label rect_size? (Default is a decent estimate)
export(Vector2) var label_rect_size = Vector2(265, 100)

# The new overhead dialogue - we need this to override the old overhead dialogue
var new_overhead : Spatial

# When true, the first text option given is *always* overhead_dialogue_text[0] (randomisation is overridden) 
var firstTime = true  
# Which text index should be used next?
var currentTextIdx = 0
var in_body = false

func _ready():
	validate_dialogue()

func _on_click_body_entered(body: ClickPointer):
	if body and check_if_safe():  # Pointer.player_clicked
		Pointer.set_node_entered(self)
#		execute_dialogue()  # dialogue is executed in Pointer when clicked


func execute_dialogue():
#	if new_overhead and is_instance_valid(new_overhead):
#		yield(new_overhead, "dialogue_finished")
	Pointer.disable_pointer()
	start_overhead_dialogue()
#	yield(new_overhead, "dialogue_start_fading")
	Pointer.enable_pointer()


func _on_click_body_exited(body: ClickPointer):
	if body:
#		print_debug(self.name, " -> body_entered")
		pass



func start_overhead_dialogue():
	var current_dialogue = get_next_dialogue()
	new_overhead = SceneOverheadDialogue.instance()
	var _x = connect("setup_instance", new_overhead, "_on_setup_instance")
	new_overhead.connect_signals_to_parent(self)
	add_child_dialogue(new_overhead)
	
	# I'm a bit split on this "idle_frame" thing. It looks a lot cleaner but
	# I don't like relying on a frame to occur. I guess it doesn't really matter
	# but it is something to keep in mind to avoid. 
	# In this idle frame, the child is added and the _ready() function sets up all the nodes
	yield(get_tree(), "idle_frame")
	
	emit_signal("setup_instance", overhead_dialogue_scale, current_dialogue, label_rect_size)
	
	if is_pickupable and !was_item_picked_up:
		if !item_resource:
			print_debug(name, " has an invalid item_scene: ", item_resource)
			return
		was_item_picked_up = inventory.add_item(item_resource)
#		print_debug("Item (%s) was added: " % item_resource.name, was_item_picked_up)


func get_next_dialogue():
	if firstTime:
		firstTime = false
		return overhead_dialogue_text[0]
	if overhead_dialogue_text.size() == 1:
		return overhead_dialogue_text[0]

	# Randomises the dialogue options (it would be good if we could prevent reoccurences)
	if randomize_dialogue:
		randomize()
#		print_debug("Randomising dialogue")
		var random_idx = randi() % overhead_dialogue_text.size() - 1
		if random_idx == currentTextIdx:
			currentTextIdx = cycle_number(currentTextIdx, overhead_dialogue_text)
			return overhead_dialogue_text[currentTextIdx]
		return overhead_dialogue_text[random_idx]

	# Cycles through the indexes and wraps back to 0
	currentTextIdx = cycle_number(currentTextIdx, overhead_dialogue_text)
	return overhead_dialogue_text[currentTextIdx]


# Cycles a number based on arr.size() and wraps to 0 if greater than arr.size()
func cycle_number(num: int, arr: Array):
	if ((num + 1) > (arr.size() - 1)):
		num = 0
	else:
		num += 1
	return num


func validate_dialogue():
	if !overhead_dialogue_text or !overhead_dialogue_text[0]:
		print_debug("overhead_dialogue_text is invalid: ", name, " is '", overhead_dialogue_text, "' @", self)
		overhead_dialogue_text = ["No text set"]


func set_dialogue_scale(value: Vector3):
	overhead_dialogue_scale = value
func get_dialogue_scale():
	return overhead_dialogue_scale
