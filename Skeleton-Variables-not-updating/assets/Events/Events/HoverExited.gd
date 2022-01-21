extends Event
class_name HoverExited

var node_entered

func _init() -> void:
	event_name = "HoverExited"


func execute():
	HoverDescriptor.reset_to_default_state()


func setup_event(args=[]):
	priority = 1
	if args:
		pass
	execute()
