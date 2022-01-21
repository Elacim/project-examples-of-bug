extends Node
class_name Event_Manager

signal event_queue_empty
signal event_queue_started
signal event_queue_finished

# Each priority is an index in an array. For example: Priority 0 events are
# placed into index 0's array | Priority 5 events are in index 5's array
# The lowest priority (i.e. 0) goes first
var event_queue := []
var e_q = []
var priority_range_default := 2  # at the moment, we only need two priority levels
# it is technically redundant to have a bool checking if the queue is empty, but it 
# should give a small performance boost, as it stops the queue being searched *every* frame 
#var are_events_in_queue = false setget set_events_in_queue, get_events_in_queue
var are_events_in_queue = false

#func _ready() -> void:
	# warning-ignore:return_value_discarded
#	connect("event_queue_empty", self, "_on_event_queue_empty")
#	setup_manager()

func _init() -> void:
	var _x = connect("event_queue_empty", self, "_on_event_queue_empty")
	set_physics_process(true)  # it shouldn't need to be set manually, and it doesn't even work
	setup_manager()

func setup_manager():
	event_queue = [ [], [] ]
	are_events_in_queue = false
	
func set_are_events_in_queue(value: bool):
	are_events_in_queue = value
func get_are_events_in_queue() -> bool:
	return are_events_in_queue

func add_to_event_queue(event: Event):
	if (event):
		print(event.event_name)
		# if the priority is greater than the size, append a new array
		if (event.priority > event_queue.size() - 1):
			print("Event priority ", event.priority, " Queue size: ", event_queue.size())
			# this system could be a bit more flexible - if the priority is greater
			# than event_queue.size(), there'll be a catastrophic desync. Right now we'll push an error
			# and fix it later
			push_error("Event.priority (%s -> %s) greater than event_queue.size() (%s)" % \
						[event, event.priority, event_queue])
			event_queue.append([event])
		else:
			event_queue[event.priority].append(event)
		are_events_in_queue = true
		print("Event added to queue: ", event)
		print_debug(are_events_in_queue)
		print_debug(event_queue)
		print("-------")

func _physics_process(delta: float) -> void:
	print("Physics process is, for some reason, not running")
	if are_events_in_queue:
		print("Queue started")
		emit_signal("event_queue_started")
		var all_events = get_all_events_in_queue()
		for i in all_events.size():
			var current_event = all_events.pop_front()
			current_event.setup_event()
			current_event.execute()
		emit_signal("event_queue_empty")
	return


func get_all_events_in_queue():
	var current_events = []
	for _i in range(0, 200):
		var e = get_lowest_priority_event()
		if e:
			current_events.append(e)
		else:
			break
	if !current_events:
		emit_signal("event_queue_empty")
	return current_events

func get_lowest_priority_event() -> Event:
	# Each priority is an index in event_queue, so whatever is the lowest priority
	# is first selected and then
	for priority_array in event_queue:
		if !priority_array.empty():  # are there any events in the array?
			# Priority array is a reference to event queue's array
			return priority_array.pop_front()  # if so, give the first event
	are_events_in_queue = false
	return null  # if no event is found


# All signal functions
func _on_event_queue_empty():
	set_are_events_in_queue(false)

