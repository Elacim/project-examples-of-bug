extends Area_Generic
class_name Area_Popup

const ScenePopupDialogue = preload("res://Assets/Clicks/_ClickInstances/Instanced_Popup_Dialogue.tscn")

# [Optional] What timeline should this clickArea point to?
# If not set, dialogue isn't executed
export(String) var dialogic_timeline = "" setget set_timeline_key, get_timeline_key



func _on_click_body_entered(body: ClickPointer):
	if body:
		pass


func on_click_body_exited(body: ClickPointer):
	if body:
		pass



func set_timeline_key(value: String):
	if value:
		dialogic_timeline = value
		property_list_changed_notify()
func get_timeline_key():
	return dialogic_timeline  # dialogicTimelineKey
