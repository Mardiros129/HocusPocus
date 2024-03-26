extends TileMap


@onready var quad_temp

@onready var quad0_data: Array
@onready var quad1_data: Array
@onready var quad2_data: Array
@onready var quad3_data: Array

@onready var quadrant0: Array
@onready var quadrant1: Array
@onready var quadrant2: Array
@onready var quadrant3: Array

@onready var can_rotate = false
@export var map_size = 10


func _ready():
	# Check all cells in the grid. Magic number, change later.
	for x in map_size:
		for y in map_size:
			var my_tile = get_cell_tile_data(1, Vector2i(x, y), false)
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

func _process(delta):
	if can_rotate:
		if Input.is_action_just_pressed("rotate_left"):
			rotate_group_left()
		elif Input.is_action_just_pressed("rotate_right"):
			rotate_group_right()

func rotate_group_left():
	save_tile_data()
	quad_temp = quadrant0
	quadrant0 = quadrant3
	quadrant3 = quadrant2
	quadrant2 = quadrant1
	quadrant1 = quad_temp
	generate_new_cells()

func rotate_group_right():
	save_tile_data()
	quad_temp = quadrant0
	quadrant0 = quadrant1
	quadrant1 = quadrant2
	quadrant2 = quadrant3
	quadrant3 = quad_temp
	generate_new_cells()

# Helper function
func save_tile_data() -> void:
	for x in quadrant0.size():
		quad0_data.append(get_cell_atlas_coords(0, quadrant0[x], false))
	for x in quadrant1.size():
		quad1_data.append(get_cell_atlas_coords(0, quadrant1[x], false))
	for x in quadrant2.size():
		quad2_data.append(get_cell_atlas_coords(0, quadrant2[x], false))
	for x in quadrant3.size():
		quad3_data.append(get_cell_atlas_coords(0, quadrant3[x], false))

# Helper function
func generate_new_cells() -> void:
	# Erase old cells
	for x in quadrant0.size():
		erase_cell(0, quadrant0[x])
	for x in quadrant1.size():
		erase_cell(0, quadrant1[x])
	for x in quadrant2.size():
		erase_cell(0, quadrant2[x])
	for x in quadrant3.size():
		erase_cell(0, quadrant3[x])
	
	# Draw new cells
	for x in quadrant0.size():
		set_cell(0, quadrant0[x], 0, quad0_data[x], 0)
	for x in quadrant1.size():
		set_cell(0, quadrant1[x], 0, quad1_data[x], 0)
	for x in quadrant2.size():
		set_cell(0, quadrant2[x], 0, quad2_data[x], 0)
	for x in quadrant3.size():
		set_cell(0, quadrant3[x], 0, quad3_data[x], 0)

func _on_area_2d_area_entered(area):
	can_rotate = true
	print("Player entered.")

func _on_area_2d_area_exited(area):
	can_rotate = false
