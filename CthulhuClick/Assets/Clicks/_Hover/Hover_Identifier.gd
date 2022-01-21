extends Area

signal set_hover_identifier(identifier)
onready var coll = $CollisionShape


#		print(get_parent().hover_area)
# Called when the node enters the scene tree for the first time.
# It should be triggered first as it's a child - children are setup first
func _ready() -> void:
	var parent = get_parent_spatial()
	if parent:
		parent.hover_area_coll = $CollisionShape
		parent.hover_area = self
		var _x
		if parent.has_method("_on_hover_identifier_entered"):
			_x = connect("body_entered", parent, "_on_hover_identifier_entered")
		if parent.has_method("_on_hover_identifier_exited"):
			_x = connect("body_exited", parent, "_on_hover_identifier_exited")

		if parent.has_method("_on_child_set_hover_identifier"):
			_x = connect("set_hover_identifier", parent, "_on_child_set_hover_identifier")
			emit_signal("set_hover_identifier", self)
		if parent.has_method("_on_hovering_over_area"):
			_x = connect("hovering_over_area", parent, "_on_hovering_over_area")
		if _x != OK:
			push_error("Couldn't connect signal - %s" % _x)
