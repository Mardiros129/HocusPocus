extends Node2D

@onready var game_world = $GameWorld

@onready var tile0_loc = Vector2(1, 2)
@onready var tile1_loc = Vector2(1, 4)
@onready var tile2_loc = Vector2(3, 4)
@onready var tile3_loc = Vector2(3, 2)
@onready var tile_temp_loc

@onready var tile0_data
@onready var tile1_data
@onready var tile2_data
@onready var tile3_data

@onready var can_rotate = false
@onready var character = $Character


func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			get_tree().quit()
			
		if event.pressed and event.keycode == KEY_SPACE:
			if can_rotate:
				rotate_group()
			
func rotate_group():
	# Save tile data
	tile0_data = game_world.get_cell_atlas_coords(0, tile0_loc, false)
	tile1_data = game_world.get_cell_atlas_coords(0, tile1_loc, false)
	tile2_data = game_world.get_cell_atlas_coords(0, tile2_loc, false)
	tile3_data = game_world.get_cell_atlas_coords(0, tile3_loc, false)
	
	# Save tile location
	tile_temp_loc = tile0_loc
	tile0_loc = tile1_loc
	tile1_loc = tile2_loc
	tile2_loc = tile3_loc
	tile3_loc = tile_temp_loc
	
	# Erase old cells
	game_world.erase_cell(0, tile0_loc)
	game_world.erase_cell(0, tile1_loc)
	game_world.erase_cell(0, tile2_loc)
	game_world.erase_cell(0, tile3_loc)
	
	# Draw new cells
	game_world.set_cell(0, tile0_loc, 0, tile0_data, 0)
	game_world.set_cell(0, tile1_loc, 0, tile1_data, 0)
	game_world.set_cell(0, tile2_loc, 0, tile2_data, 0)
	game_world.set_cell(0, tile3_loc, 0, tile3_data, 0)

func _on_area_2d_area_entered(area):
	can_rotate = true

func _on_area_2d_area_exited(area):
	can_rotate = false
