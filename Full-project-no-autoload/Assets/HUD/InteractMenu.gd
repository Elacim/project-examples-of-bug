#extends PopupMenu
extends Node2D

onready var popup_menu = $InteractMenu
var padding_amount = 5
#var pad_string = "%*.*s"
# https://docs.godotengine.org/en/stable/getting_started/scripting/gdscript/gdscript_format_string.html#format-specifiers
var pad_string = "%*s"
var examine_text = pad_string % [padding_amount, "Examine"] 
var use_text = pad_string % [padding_amount, "Use"] 
var is_open = false setget set_open, get_open

# Though the text is annoying, it's more important to work on stuff that matters
# Like the inventory system and the actual mechanics of examine/use
# Small details are done last.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	popup_menu.clear()
	popup_menu.add_item(examine_text, 0)

	popup_menu.add_separator("", 1)
#	popup_menu.add_separator("", 2)
	popup_menu.add_item("      Use", 2)
	popup_menu.call_deferred("popup")

	pass


func _on_InteractMenu_id_pressed(id: int) -> void:
	print(id, " pressed")
	pass


func set_open(value: bool):
	is_open = value
func get_open():
	return is_open
