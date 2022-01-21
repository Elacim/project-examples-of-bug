extends Spatial

onready var viewport = $Viewport
onready var text_node = $Viewport/HoverText
onready var sprite = $DialogueSprite

# Fade in/out timers
onready var fade_in_timer = $DialogueSprite/TickUpFade
onready var fade_out_timer = $DialogueSprite/TickDownFade
var fade_increment = 0.05
var center_bbcode = "[center]%s[/center]"

#var hover_event_manager = preload("res://Assets/Events/EventManager.gd").new()
var hover_event_manager = Event_Manager.new()
var hover_enter_event = preload("res://Assets/Events/Events/HoverEntered.gd")
var hover_exit_event = preload("res://Assets/Events/Events/HoverExited.gd")


func _ready() -> void:
#	event_manager.setup_manager()
	if get_parent_spatial():
		get_parent().hover_area_coll = $CollisionShape
		get_parent().hover_area = self
	fade_out_timer.connect("timeout", self, "_TickDownFade_timeout")
	fade_in_timer.connect("timeout", self, "_TickUpFade_timeout")



var area_just_entered = false
var area_just_exited = false
func execute_hover_code(value: String, node):
#func execute_hover_code(value: String):
	if !value or !node: return 
#	if !value: return 
	else: pass
	area_just_entered = true
	if area_just_exited:
		
		pass
	sprite.show()
	reset_to_default_state()
	set_text(value)
	area_just_entered = false


func add_hover_entered_event(text, _node):
	var new_event = hover_enter_event.new()
	new_event.event_text = center_bbcode % text
	hover_event_manager.add_to_event_queue(new_event)
func add_hover_exited_event(_node):
	var new_event = hover_exit_event.new()
	hover_event_manager.add_to_event_queue(new_event)

# So when the pointer exits the click_area, this code is exectured which is fine
# But on the same frame, the pointer is in another click_area, triggering
# execute_hover_code. Maybe we could
# I'm going to set the process priority of hover identifiers to lower
# We are delirious from lack of sleep. goodnight, love you
func pointer_exited_hover_area():
#	if fade_out_timer.is_stopped():
	if area_just_entered: 
		area_just_entered = false
		return
	area_just_exited = true
	sprite.hide()
	reset_to_default_state()
	fade_out_timer.start()
#	print_debug("Pointer exited")


# not a true setget, but it (should) works
func set_text(value: String):
	reset_to_default_state()
	text_node.bbcode_text = "[center]" + value + "[/center]"
	fade_in_timer.start()
func get_text():
	return text_node.bbcode_text


func reset_to_default_state():
#	area_just_exited = false
#	sprite.hide()
	sprite.opacity = 0  # 0 for fading into 1
	fade_in_timer.stop()
	fade_out_timer.stop()

# Fade in and keep there when the area is entered
# Fade out when the area is left (don't queue_free())

func _TickUpFade_timeout():
	sprite.opacity += fade_increment
	if sprite.opacity >= 1:
		fade_in_timer.stop()

func _TickDownFade_timeout():
	sprite.opacity -= fade_increment
	if sprite.opacity <= 0:
		fade_out_timer.stop()


func setup_viewport(hover_text):
	text_node.bbcode_text = "[center]" + hover_text + "[/center]"
	sprite.texture = viewport.get_texture()
	
