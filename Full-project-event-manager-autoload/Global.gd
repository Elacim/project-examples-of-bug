extends Node

var player = null
var HUD = null
var nav_node = null
var camera = null
var pointer = null
var prevent_popup = false
var debug_no_popups = false
const LANGUAGES = {  # I was going to point to a translated timeline but that doesn't work.
				"ENGLISH" : "EN",
				"FRENCH" : "FR"
				}
enum INTERACT_TYPE {
	
}
# can be done like calling a method (LANG.LANG), or done like getting a dict key LANG["LANG"]
var language = LANGUAGES.ENGLISH setget set_language, get_language

#func _input(event: InputEvent) -> void:
#	if event is InputEventMouseButton:
#		pass


func reparent_camera_to_target(target):
	get_node("../World").call_deferred("remove_child", camera)
	target.call_deferred("add_child", camera)
	camera.call_deferred("set_owner", target)
	camera.adjust_transform(null, null, null, true)

func set_pointer(value):
	if value:
		pointer.enable_pointer()
	else:
		pointer.disable_pointer()

func set_language(value):
	if value in LANGUAGES:
		language = value
func get_language():
	return language



