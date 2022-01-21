extends Area
class_name Click_Generic

"""
Template for all click areas. 
I'm starting to think we might be able to delete all of the 
click area scripts apart from this one (click_generic).
Their only purpose now is to tell the Type when they are entered/exited.
We *could* store info like 'firstTime' in here - we wouldn't need
scripts for all of these though.
"""
signal set_click_area(area)

var parent : Spatial
onready var coll = $CollisionShape

func _ready() -> void:
	parent = get_parent_spatial()
	if parent:
#		if get_parent().has_method("_on_child_set_hover_identifier"):
#			connect("set_hover_identifier", get_parent(), "_on_child_set_hover_identifier")
#			emit_signal("set_hover_identifier", self)
		if parent.has_method("_on_child_set_click_area"):
			var _x = connect("set_click_area", parent, "_on_child_set_click_area")
			emit_signal("set_click_area", self)
		if parent.has_method("_on_body_entered"):
			var _x = connect("body_entered", parent, "_body_entered_area")
			_x = connect("body_exited", parent, "_body_exited_area")
	else:
		print_debug("Parent is: ", parent)
		print_stack()
