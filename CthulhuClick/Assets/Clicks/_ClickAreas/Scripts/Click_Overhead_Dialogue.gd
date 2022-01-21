extends Click_Generic
class_name Click_Overhead_Dialogue

var SceneOverheadDialogue = preload("res://Assets/Clicks/_ClickInstances/Instanced_Overhead_Dialogue.tscn")
#var SceneOverheadDialogue = load("res://Assets/ClickTypes/Type_OVERHEAD_DIALOGUE.tscn")
export(Vector2) var label_rect_size = Vector2(265, 100)
var currentText = 0
var firstTime = true
var new_overhead



#		if is_instance_valid(new_overhead):  # delete the previous dialogue
#			print("dialogue deleted")
#			new_overhead.queue_free()
#		Pointer.enable_pointer()




