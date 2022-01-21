extends Spatial

signal player_clicked(value)

const MOVE_MARGIN = 400
const MOVE_SPEED = 30

const ray_length = 1000
onready var cam = $Camera

export(int) var raycast_collision_flag = 49  # 49 covers World (1), Areas (16), & Hovers (32)
export(bool) var deselect_on_cycle = true
export(bool) var enable_multiple_clicks = false  # stops accidental reclicking of an area
var new_rot = rotation_degrees.y
var rot_offset = 2
var offset_from_player = Vector3(-30, -40, 0)
var engine_fps = Engine.iterations_per_second
onready var click_node = $MaxClickRange

func _ready():
	var _x = connect("player_clicked", Pointer, "_on_player_clicked")
	Global.camera = self


func adjust_transform(new_trans, new_fov, new_rot_deg, default=false) -> void:
	if default:
		translate(Vector3(0, -10, -44))  # Global.camera.
		cam.fov = 30  # Global.camera.
		rotation_degrees = Vector3(-22, -90, 0)
	else:
		translate(new_trans)
		cam.fov = new_fov
		rotation_degrees = new_rot_deg


# The camera reparenting for !move_using_clicking is done by the Player.gd script
func _process(delta):
	if Pointer.is_pointer_disabled():
		calc_move(delta)
		if is_rotating:
			if is_rotating_right:
				new_rot = adjust_rotation(new_rot + rot_offset)
			else:
				new_rot = adjust_rotation(new_rot - rot_offset)
		rotation_degrees.y = new_rot


var player_clicked = false
func _physics_process(_delta):
#	if player_clicked:
	# In short, this makes a static body go to a location, and
	# if it's an Area3D, it should trigger the appropriate code
	# If you find it doesn't work anymore, first check the collision layers/masks - very important.
	# The ClickArea should have 5 on collision layer, and 3 on collision mask.
	# The ClickPointer should have 3 on layers, and 1 & 2 & 5 on masks. 
	if Pointer.is_pointer_disabled(): return
	var collidersAndCollisions = raycast_from_mouse(get_viewport().get_mouse_position())
	var is_valid_raycast = check_raycast(collidersAndCollisions)
	if is_valid_raycast[1]:
		Pointer.move_pointer_to_area(collidersAndCollisions[1]["position"])
	elif is_valid_raycast[0]:
		Pointer.move_pointer_to_area(collidersAndCollisions[0]["position"])


func is_click_in_range() -> bool:
	return click_node.overlaps_body(Pointer)


var is_rotating := false
var is_rotating_right := true
func _input(event):
	if event is InputEventMouseMotion:
		pass
	else:
#		var m_pos = get_viewport().get_mouse_position()
		if Input.is_action_pressed("camera_rotate_clockwise"):
			is_rotating = true
			is_rotating_right = true
		if Input.is_action_pressed("camera_rotate_anti_clockwise"):
			is_rotating = true
			is_rotating_right = false
		if Input.is_action_just_released("camera_rotate_anti_clockwise") or \
		   Input.is_action_just_released("camera_rotate_clockwise"):
			is_rotating = false
#		if Input.is_action_just_pressed("main_command"):
#			move_player(m_pos)
		if Input.is_action_just_pressed("player_clicked_location"):
			emit_signal("player_clicked")


func adjust_rotation(rot):
	var stepped_rot = stepify(round(rot), rot_offset)
	if stepped_rot >= 360 or stepped_rot <= -360:
		stepped_rot = 0
	return stepped_rot

#func calc_move(m_pos, delta):
func calc_move(delta):
#	var v_size = get_viewport().size
	var move_vec = Vector3()
	if Input.is_action_pressed("camera_move_left"):
		move_vec.x -= 1
	if Input.is_action_pressed("camera_move_forward"):
		move_vec.z -= 1
	if Input.is_action_pressed("camera_move_right"):
		move_vec.x += 1
	if Input.is_action_pressed("camera_move_backward"):
		move_vec.z += 1
#	print(move_vec)
#	lerp(cur_pos, new_pos, 0.1)
	if move_vec:
		var amount = move_vec * delta * MOVE_SPEED
		amount = Vector3(amount.x, 0, amount.z)
#		print_debug(amount)
#		global_translate(amount)  # local coords - half fixes the problem
		translate(amount)  # local coords - half fixes the problem


func move_player(m_pos):
	var result = raycast_from_mouse(m_pos)
	if result:
		Global.player.move_to(result.position)

func raycast_from_mouse(m_pos):
	var ray_start = cam.project_ray_origin(m_pos)
	var ray_end = ray_start + cam.project_ray_normal(m_pos) * ray_length
	var space_state = get_world().direct_space_state
	# click/in_range_collision -> 4 and 16 are bitlayers. 4 only collides with ClickAreas
	# and the 16 only collides with the MaxClickRange Area
	var body_collision = space_state.intersect_ray(ray_start, ray_end, [], raycast_collision_flag, true, false) # collides with bodies
	var area_collision = space_state.intersect_ray(ray_start, ray_end, [], raycast_collision_flag, false, true) # collides with areas
	# Bit layers: Bit 1 [World + Bit 4 [ClickAreas] + Bit 5 [HoverIdentifier] (1 + 16 + 32) = 48
	return [body_collision, area_collision]

func check_raycast(collisions):
#	print(collisions)
	var result := [null, null]
	if collisions[0]:
		result[0] = true
	else:
		result[0] = false
	if collisions[1]:
		result[1] = true
	else:
		result[1] = false
#	print_debug("Collisions: ", result)
	return result
