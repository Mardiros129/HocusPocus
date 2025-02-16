extends TileMap

@onready var map_size = -1
@export var movable_layer: int
var character
@export var next_level: PackedScene
@export var door_locked = true
@onready var processing = false

func _ready():
	for n in get_layers_count():
		var all_cells = get_used_cells(n)
		for m in all_cells.size():
			if all_cells[m][0] > map_size:
				map_size = all_cells[m][0]
			if all_cells[m][1] > map_size:
				map_size = all_cells[m][1]
				
	map_size += 1
	print("Map size is " + str(map_size))
	
	var child_nodes = get_children(false)
	for n in child_nodes.size():
		if child_nodes[n].is_in_group("Rotator"):
			generate_rotator_quadrants(child_nodes[n])
			child_nodes[n].rotate.connect(_on_rotator_rotate)


func generate_rotator_quadrants(rotator):
	# First, find the correct layer.
	for n in get_layers_count():
		if get_layer_name(n) == rotator.layer_name:
			rotator.layer_number = n
			break
	
	var quadrant0: Array[Vector2i]
	var quadrant1: Array[Vector2i]
	var quadrant2: Array[Vector2i]
	var quadrant3: Array[Vector2i]
	
	for x in map_size:
		for y in map_size:
			var my_tile = get_cell_tile_data(rotator.layer_number, Vector2i(x, y), false)
			if my_tile != null:
				var quadrant = my_tile.get_custom_data("Quadrant")
				
				# Add to the appropriate quadrant array.
				if quadrant == 0:
					quadrant0.append(Vector2i(x, y))
				elif quadrant == 1:
					quadrant1.append(Vector2i(x, y))
				elif quadrant == 2:
					quadrant2.append(Vector2i(x, y))
				elif quadrant == 3:
					quadrant3.append(Vector2i(x, y))
	
	# Set the quadrants for the rotator.
	rotator.quadrant0 = quadrant0
	rotator.quadrant1 = quadrant1
	rotator.quadrant2 = quadrant2
	rotator.quadrant3 = quadrant3


# ***** Need to refactor later, very icky *****
func rotate_character(quadrant0: Array[Vector2i], quadrant1: Array, quadrant2: Array, quadrant3: Array, go_right: bool):
	var char_loc:Vector2i = character.my_loc
	
	for n in quadrant0.size():
		if quadrant0[n] == char_loc:
			if go_right:
				character.instant_move(quadrant1[n])
			else:
				character.instant_move(quadrant3[n])
	for n in quadrant1.size():
		if quadrant1[n] == char_loc:
			if go_right:
				character.instant_move(quadrant2[n])
			else:
				character.instant_move(quadrant0[n])
	for n in quadrant2.size():
		if quadrant2[n] == char_loc:
			if go_right:
				character.instant_move(quadrant3[n])
			else:
				character.instant_move(quadrant1[n])
	for n in quadrant3.size():
		if quadrant3[n] == char_loc:
			if go_right:
				character.instant_move(quadrant0[n])
			else:
				character.instant_move(quadrant2[n])


func _on_rotator_rotate(quadrant0, quadrant1, quadrant2, quadrant3, go_right):
	if not processing:
		rotate_character(quadrant0, quadrant1, quadrant2, quadrant3, go_right)
		
		# Save tile data.
		var quad0_data: Array[Vector2i]
		var quad1_data: Array[Vector2i]
		var quad2_data: Array[Vector2i]
		var quad3_data: Array[Vector2i]
		
		for n in quadrant0.size():
			quad0_data.append(get_cell_atlas_coords(movable_layer, quadrant0[n], false))
		for n in quadrant1.size():
			quad1_data.append(get_cell_atlas_coords(movable_layer, quadrant1[n], false))
		for n in quadrant2.size():
			quad2_data.append(get_cell_atlas_coords(movable_layer, quadrant2[n], false))
		for n in quadrant3.size():
			quad3_data.append(get_cell_atlas_coords(movable_layer, quadrant3[n], false))
		
		# Rotate right or left.
		var quad_temp
		if go_right:
			quad_temp = quadrant0
			quadrant0 = quadrant1
			quadrant1 = quadrant2
			quadrant2 = quadrant3
			quadrant3 = quad_temp
		else:
			quad_temp = quadrant0
			quadrant0 = quadrant3
			quadrant3 = quadrant2
			quadrant2 = quadrant1
			quadrant1 = quad_temp
		
		# Erase old cells
		for n in quadrant0.size():
			erase_cell(movable_layer, quadrant0[n])
		for n in quadrant1.size():
			erase_cell(movable_layer, quadrant1[n])
		for n in quadrant2.size():
			erase_cell(movable_layer, quadrant2[n])
		for n in quadrant3.size():
			erase_cell(movable_layer, quadrant3[n])
		
		# Draw new cells
		for n in quadrant0.size():
			set_cell(movable_layer, quadrant0[n], 0, quad0_data[n], 0)
		for n in quadrant1.size():
			set_cell(movable_layer, quadrant1[n], 0, quad1_data[n], 0)
		for n in quadrant2.size():
			set_cell(movable_layer, quadrant2[n], 0, quad2_data[n], 0)
		for n in quadrant3.size():
			set_cell(movable_layer, quadrant3[n], 0, quad3_data[n], 0)
		
		if quadrant0.size() != quadrant1.size() || quadrant0.size() != quadrant2.size() || quadrant0.size() != quadrant3.size():
			print("Quadrant sizes are not the same.")


# Sets the character to a var. Need to change later ***
func _on_child_entered_tree(node):
	if node.name == "Character":
		character = get_node("Character")
		character.game_world = self
		disconnect("child_entered_tree", Callable(self, "_on_child_entered_tree"))
		character.level_complete.connect(_level_complete)
		character.got_key.connect(_got_key)
		character.processing_started.connect(_processing_started)
		character.processing_stopped.connect(_processing_stopped)

func _level_complete():
	if !door_locked:
		if next_level == null:
			get_tree().quit()
		else:
			get_tree().change_scene_to_packed(next_level)

func _got_key():
	door_locked = false

func _processing_started():
	processing = true

func _processing_stopped():
	processing = false
