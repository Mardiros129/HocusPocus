extends TileMap


@export var tile0_loc: Vector2
@export var tile1_loc: Vector2
@export var tile2_loc: Vector2
@export var tile3_loc: Vector2
@onready var tile_temp_loc

@onready var tile0_data
@onready var tile1_data
@onready var tile2_data
@onready var tile3_data

@onready var can_rotate = false


#func _ready():
	

func _process(delta):
	if Input.is_action_just_pressed("rotate_key"):
		if can_rotate:
				rotate_group()

func rotate_group():
	# Save tile data
	tile0_data = get_cell_atlas_coords(0, tile0_loc, false)
	tile1_data = get_cell_atlas_coords(0, tile1_loc, false)
	tile2_data = get_cell_atlas_coords(0, tile2_loc, false)
	tile3_data = get_cell_atlas_coords(0, tile3_loc, false)
	
	# Save tile location
	tile_temp_loc = tile0_loc
	tile0_loc = tile1_loc
	tile1_loc = tile2_loc
	tile2_loc = tile3_loc
	tile3_loc = tile_temp_loc
	
	# Erase old cells
	erase_cell(0, tile0_loc)
	erase_cell(0, tile1_loc)
	erase_cell(0, tile2_loc)
	erase_cell(0, tile3_loc)
	
	# Draw new cells
	set_cell(0, tile0_loc, 0, tile0_data, 0)
	set_cell(0, tile1_loc, 0, tile1_data, 0)
	set_cell(0, tile2_loc, 0, tile2_data, 0)
	set_cell(0, tile3_loc, 0, tile3_data, 0)

func _on_area_2d_area_entered(area):
	can_rotate = true
	print("hi")

func _on_area_2d_area_exited(area):
	can_rotate = false
