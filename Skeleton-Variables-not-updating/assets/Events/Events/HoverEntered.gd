extends Event
class_name HoverEntered

var node_entered
var event_text : String
var hover_node : Area

func _init() -> void:
	event_name = "HoverEntered"


func execute():
	HoverDescriptor.set_text(event_text)

func setup_event(args=[]):
	priority = 0
	event_name = "HoverEntered"
	if args:
		event_text = args[0]
#		hover_node = args[1]
	execute()
