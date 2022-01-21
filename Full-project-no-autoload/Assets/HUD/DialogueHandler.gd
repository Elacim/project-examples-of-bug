extends Node
class_name dialogue_handler
# This should be a class that can have each timeline stored in it
# with all the needed details to initialise it

var timeline : String

func _init(_timeline: String):
	if !_timeline:
		assert(false)
		Logger.log_event("Timeline invalid (%s)" % _timeline, self, "_init", Logger.SEVERITY.ERROR)
	self.timeline = _timeline
	setup_dialogue()

func setup_dialogue():
	timeline = Global.get_language() + timeline
	start_dialogic()
	
func start_dialogic():
	var dialogue = Dialogic.start(timeline)
	var _x = dialogue.connect("timeline_end", self, "timeline_ended")
	_x = dialogue.connect("timeline_start", self, "timeline_started")
	Global.pointer.disable_pointer()
	
func timeline_ended(_ended_timeline):
	Global.pointer.enable_pointer()
