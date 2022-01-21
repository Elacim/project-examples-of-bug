extends RigidBody
class_name ClickPointer

onready var coll = $CollisionShape
var miscTools = MiscTools.new()
var previous_node_entered setget set_node_entered, get_node_entered

func set_node_entered(value: Spatial):
	if value:
		previous_node_entered = value
func get_node_entered():
	return previous_node_entered


# There's a bug right now with previous_node_entered triggering it's dialogue every
# time the player clicks while the pointer is disabled/not on another click_area
# I think this is a really cool feature, but it would be good to have a dedicated button
# for it - I'm thinking like a "repeat that last interaction button"

func _on_player_clicked():
	if previous_node_entered:
		# So, we can either 1. connect (then disconnect) the execute_node_dialogue signal
		# Or 2. directly call "execute_dialogue". I don't see the disadvantage of 2 as
		# long as we check to see if it exists first (and it must exist)
		if previous_node_entered.has_method("execute_dialogue"):
			previous_node_entered.execute_dialogue()
		else:
			print_debug("previous_node_entered (%s) has no '_on_execute_node_dialogue'" % previous_node_entered)
	set_node_entered(null)
	move_to_void()


func disable_pointer():
#	print_debug("disabled")
	miscTools.set_bit_mask(self, [4], false)
#	coll.set_deferred("disabled", true)
#	move_to_void()
func enable_pointer():
#	print_debug("enabled")
	miscTools.set_bit_mask(self, [4], true)
#	coll.set_deferred("disabled", false)
#	move_to_void()
	
func is_pointer_disabled():
	return !get_collision_mask_bit(4)
	
func move_pointer_to_area(pos):
	transform[3] = pos

# Exists so we can have a single-click option
func move_to_void():
	move_pointer_to_area(Vector3(0, -999999, 0))
