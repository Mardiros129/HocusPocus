extends CharacterBody2D

# The grid location of the character
@onready var location = Vector2i(0, 0)
@onready var target_loc = Vector2i(0, 0)
@export var speed = 300.0

@export var tile_size = 64
@onready var offset
@onready var game_world

signal level_complete
signal got_key

enum {STANDING, MOVING, SLIDING}
@onready var state = STANDING

func _ready():
	offset = tile_size / 2
	location[0] = (position.x - offset) / tile_size
	location[1] = (position.y - offset) / tile_size
	target_loc[0] = location[0]
	target_loc[1] = location[1]

func _process(delta):
	if state == MOVING:
		var delta_speed = delta * speed
		var target_position = Vector2i(target_loc[0] * tile_size + offset, target_loc[1] * tile_size + offset)
		
		# Consider refactoring later
		if target_loc.x != location.x:
			var direction = target_loc.x - location.x
			position.x += delta_speed * direction
			# Going left
			if direction < 0 && target_position.x >= position.x:
				location.x = target_loc.x
			# Going right
			elif direction > 0 && target_position.x <= position.x:
				location.x = target_loc.x
				
		elif target_loc.y != location.y:
			var direction = target_loc.y - location.y
			position.y += delta_speed * direction
			# Going down
			if direction < 0 && target_position.y >= position.y:
				location.y = target_loc.y
			# Going up
			elif direction > 0 && target_position.y <= position.y:
				location.y = target_loc.y
		else:
			state = STANDING
		

func _input(event):
	if state == STANDING:
		if event.is_action_pressed("move_right"):
			target_loc[0] += 1.0
		if event.is_action_pressed("move_left"):
			target_loc[0] -= 1.0
		if event.is_action_pressed("move_up"):
			target_loc[1] -= 1.0
		if event.is_action_pressed("move_down"):
			target_loc[1] += 1.0
		state = MOVING
	
	for n in game_world.get_layers_count():
		var my_tile = game_world.get_cell_tile_data(n, target_loc, false)
		if my_tile != null:
			if my_tile.get_custom_data("Wall") == true:
				target_loc = location
				state = STANDING
			if my_tile.get_custom_data("ExitDoor") == true:
				emit_signal("level_complete")
			if my_tile.get_custom_data("Key") == true:
				emit_signal("got_key")
				game_world.erase_cell(n, target_loc)
		#else:
			#location = target_loc
			#self.position = Vector2(location[0] * tile_size + offset, location[1] * tile_size + offset)

# Moves the character during rotations
func move_to_loc(loc: Vector2i):
	location = loc
	target_loc = loc
	self.position = Vector2(loc.x * tile_size + offset, loc.y * tile_size + offset)
