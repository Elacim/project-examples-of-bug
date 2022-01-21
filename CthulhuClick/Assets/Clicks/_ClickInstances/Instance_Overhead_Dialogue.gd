extends Spatial

signal dialogue_started
signal dialogue_finished

# These are accessed via script, and are get_node'd.
# If we get_node them here, they aren't loaded till after
# the instance is added to the world (add_child)
var viewport = "Viewport"
var text_label = "Viewport/RichTextLabel"

onready var sprite = $DialogueSprite
onready var fade_out_timer = $DialogueSprite/StartFadeOut/TickDownFade
onready var fade_in_timer = $DialogueSprite/TickUpFade
onready var fade_out_start = $DialogueSprite/StartFadeOut

#export(float, 0.1, 10, 0.1) var dialogue_scale = 3 setget set_scale, get_scale
export(Vector3) var dialogue_scale = Vector3(3, 3, 3) setget set_scale, get_scale
var fade_time = .05

func _ready() -> void:
#	connect("dialogue_started", get_parent(), "dialogue_started")
#	connect("dialogue_ended", get_parent(), "dialogue_ended")
#	get_parent().emit_signal("dialogue_started")
	emit_signal("dialogue_started")
	set_scale(dialogue_scale)
	sprite.opacity = 0
	fade_in_timer.wait_time = fade_time
	fade_in_timer.start()


func _on_StartFadeOut_timeout() -> void:
#	print("Fading out now")
	fade_out_timer.wait_time = fade_time
	fade_out_timer.start()

func _on_TickDownFade_timeout() -> void:
	# Putting the opacity before the if-statement prevents a jerky queue_free situation
	sprite.opacity -= 0.05
	if sprite.opacity <= 0:
		# I don't think disabling the pointer is a good idea with overhead dialogue
		# It's supposed to be a quick thing rather than a cutscene type thing
		# Global.enable_pointer()
#		get_parent().emit_signal("dialogue_finished")
		emit_signal("dialogue_finished")
		queue_free()
	


# Makes the sprite fade in slowly, purely for aesthetics
func _on_TickUpFade_timeout() -> void:
	if sprite.opacity >= 1:
#		print("Starting fade out timer")
		fade_out_start.start()
		fade_in_timer.stop()   # if we don't stop this timer, then it starts adding new colours
	sprite.opacity += 0.05



func set_scale(value:=Vector3(1, 1, 1)):
#	print_debug(name, scale)
	dialogue_scale = value
	scale = value
func get_scale():
	return scale
