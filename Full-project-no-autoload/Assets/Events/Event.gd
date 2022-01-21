extends Resource
class_name Event

# The lowest priority is executed first
var priority : int  # should be within EventManager's priority_range
export(String) var event_name = ""


func execute():
	pass


# By default, we just execute the code, but this allows any arguments to be set
#func setup_event(args=[]):
#	priority = -1
#	if args:
#		pass
#	execute()
