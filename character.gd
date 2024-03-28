extends CharacterBody2D

@onready var location = Vector2i(0, 0)
@onready var target_loc
@onready var has_key = false

@export var tile_size = 64
@onready var offset
@onready var game_world

func _ready():
	offset = tile_size / 2
	location[0] = (position.x - offset) / tile_size
	location[1] = (position.y - offset) / tile_size
	target_loc = location

func _input(event):
	if event.is_action_pressed("move_right"):
		target_loc[0] += 1
	if event.is_action_pressed("move_left"):
		target_loc[0] -= 1
	if event.is_action_pressed("move_up"):
		target_loc[1] -= 1
	if event.is_action_pressed("move_down"):
		target_loc[1] += 1
	
	for n in game_world.get_layers_count():
		var my_tile = game_world.get_cell_tile_data(n, target_loc, false)
		if my_tile != null:
			if my_tile.get_custom_data("Wall") == true:
				target_loc = location
			if has_key && my_tile.get_custom_data("ExitDoor") == true:
				print("Finished!")
				get_tree().quit()
			if my_tile.get_custom_data("Key") == true:
				has_key = true
				game_world.erase_cell(n, target_loc)
		else:
			location = target_loc
			self.position = Vector2(location[0] * tile_size + offset, location[1] * tile_size + offset)

func move_to_loc(loc: Vector2i):
	location = loc
	target_loc = loc
	self.position = Vector2(loc.x * tile_size + offset, loc.y * tile_size + offset)
