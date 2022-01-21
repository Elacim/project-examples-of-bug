extends Click_Generic
class_name Click_Popup_Dialogue

#var PopupDialogScene = preload("res://Assets/Clicks/ClickInstances/Instanced_Popup_Dialogue.tscn")
var new_dialogue 

# Called when the node enters the scene tree for the first time.
func _ready():
	if parent:
		if !parent.dialogic_timeline:
			print_debug("Popup_dialogue (%s) has no timeline (In: %s, at %s)" % [name, 
			get_parent(), global_transform.origin])


# This is 'generic' because we can have duplicate bodies.
# I'm a bit worried that one instance triggering body_entered
# will cause every popup_dialogue to trigger too.
func _body_entered_area(body: ClickPointer):
	if body and !Global.pointer.is_pointer_disabled() and !Inventory.get_inv_open():
			# DialogueHandler.gd etc.
			# yield till dialogue is completed ("timeline_end")
		Global.pointer.disable_pointer()
		start_dialogue()
		if parent.is_pickupable and parent.item_scene:
			if !parent.item_scene:
				Logger.log_event("Item scene not defined. ", self, 
				"Click_Popup_Dialogue.gd -> _body_entered_area", Logger.SEVERITY.NULL_TIMELINE)
#				func log_event(event: String, object: Object, function: String, severity: int):

			# test if pickupable, if so, send item to inventory

# Once the body is entered, all the appropriate information like
# dialogic_timeline and the pointer_scene are sent
func start_dialogue():
	new_dialogue = Dialogic.start(parent.dialogic_timeline)
	var _x = new_dialogue.connect("timeline_end", self, "_timeline_ended")
	add_child(new_dialogue)
	

func _timeline_ended(_timeline):
#	print_debug("Timeline ended: ", timeline)
	if parent.item_scene:
		if Inventory.add_item_to_inventory(parent.item_scene):
#		queue_free sprite in the world
			parent.item_scene = null
	Global.pointer.enable_pointer()
