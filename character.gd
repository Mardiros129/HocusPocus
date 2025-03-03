extends CharacterBody2D

# The grid location of the character
@onready var my_loc = Vector2i(0, 0)
@onready var target_loc = Vector2i(0, 0)
@export var speed = 300.0

#magic number
@export var movable_layer = 0
@export var tile_size = 64
@onready var offset
@onready var game_world

@onready var anim_player = $Sprite2D/AnimationPlayer

@onready var has_key = false

signal level_complete
signal got_key
signal processing_started
signal processing_stopped

enum {STANDING, MOVING, SLIDING}
@onready var state = STANDING

enum {UP, DOWN, LEFT, RIGHT}
@onready var facing_direction = DOWN


func _ready():
	offset = tile_size / 2
	my_loc.x = (position.x - offset) / tile_size
	my_loc.y = (position.y - offset) / tile_size
	target_loc.x = my_loc.x
	target_loc.y = my_loc.y


func _process(delta):
	match state:
		STANDING:
			pass
		
		MOVING:
			if check_can_move(target_loc) == false:
				state = STANDING
				target_loc = my_loc
				emit_signal("processing_stopped")
			else:
				delta_move(delta)
		
		SLIDING:
			if check_can_move(target_loc) == false:
				state = STANDING
				target_loc = my_loc
				emit_signal("processing_stopped")
			else:
				delta_move(delta)


func _input(event):
	if state == STANDING:
		if event.is_action_pressed("move_right"):
			target_loc.x += 1.0
			facing_direction = RIGHT
			anim_player.play("facing_right")
			emit_signal("processing_started")
			state = MOVING
		if event.is_action_pressed("move_left"):
			target_loc.x -= 1.0
			facing_direction = LEFT
			anim_player.play("facing_left")
			emit_signal("processing_started")
			state = MOVING
		if event.is_action_pressed("move_up"):
			target_loc.y -= 1.0
			facing_direction = UP
			anim_player.play("facing_up")
			emit_signal("processing_started")
			state = MOVING
		if event.is_action_pressed("move_down"):
			target_loc.y += 1.0
			facing_direction = DOWN
			anim_player.play("facing_down")
			emit_signal("processing_started")
			state = MOVING


func check_can_move(destination_tile):
	for n in game_world.get_layers_count():
		var temp_destination_tile = game_world.get_cell_tile_data(n, destination_tile, false)
		var temp_location_tile = game_world.get_cell_tile_data(n, my_loc, false)
		
		if temp_location_tile != null:
			if temp_location_tile.get_custom_data("Wall").x == 1 && facing_direction == UP:
				return false
			elif temp_location_tile.get_custom_data("Wall").y == 1 && facing_direction == RIGHT:
				return false
			elif temp_location_tile.get_custom_data("Wall").z == 1 && facing_direction == DOWN:
				return false
			elif temp_location_tile.get_custom_data("Wall").w == 1 && facing_direction == LEFT:
				return false
		
		if temp_destination_tile != null:
			if temp_destination_tile.get_custom_data("Wall").x == 1 && facing_direction == DOWN:
				return false
			elif temp_destination_tile.get_custom_data("Wall").y == 1 && facing_direction == LEFT:
				return false
			elif temp_destination_tile.get_custom_data("Wall").z == 1 && facing_direction == UP:
				return false
			elif temp_destination_tile.get_custom_data("Wall").w == 1 && facing_direction == RIGHT:
				return false
				
			if temp_destination_tile.get_custom_data("Cliff").x == 1 && facing_direction == DOWN:
				return false
			elif temp_destination_tile.get_custom_data("Cliff").y == 1 && facing_direction == LEFT:
				return false
			elif temp_destination_tile.get_custom_data("Cliff").z == 1 && facing_direction == UP:
				return false
			elif temp_destination_tile.get_custom_data("Cliff").w == 1 && facing_direction == RIGHT:
				return false


func check_tile_type(tile_location, type):
	for n in game_world.get_layers_count():
		var my_tile = game_world.get_cell_tile_data(n, tile_location, false)
		if my_tile != null:
			if my_tile.get_custom_data(type) == true:
				return true
		else:
			return false


func clear_tile_of_type(tile_location, type):
	for n in game_world.get_layers_count():
		var my_tile = game_world.get_cell_tile_data(n, tile_location, false)
		if my_tile != null:
			if my_tile.get_custom_data(type) == true:
				game_world.erase_cell(n, tile_location)


# Moves the character based on speed and delta
func delta_move(delta):
	var delta_speed = delta * speed
	var target_position = Vector2i(target_loc[0] * tile_size + offset, target_loc[1] * tile_size + offset)
	
	if target_loc.x != my_loc.x:
		var direction = target_loc.x - my_loc.x
		position.x += delta_speed * direction
		# Going left
		if facing_direction == LEFT && target_position.x >= position.x:
			my_loc.x = target_loc.x
		# Going right
		elif facing_direction == RIGHT && target_position.x <= position.x:
			my_loc.x = target_loc.x
	
	elif target_loc.y != my_loc.y:
		var direction = target_loc.y - my_loc.y
		position.y += delta_speed * direction
		# Going up
		if facing_direction == UP && target_position.y >= position.y:
			my_loc.y = target_loc.y
		# Going down
		elif facing_direction == DOWN && target_position.y <= position.y:
			my_loc.y = target_loc.y
	
	elif check_tile_type(my_loc, "Slime") == true:
			state = SLIDING
			if facing_direction == DOWN:
				target_loc.y += 1
			elif facing_direction == UP:
				target_loc.y -= 1
			elif facing_direction == LEFT:
				target_loc.x -= 1
			elif facing_direction == RIGHT:
				target_loc.x += 1
	
	else:
		state = STANDING
		emit_signal("processing_stopped")
		if check_tile_type(my_loc, "Key") == true:
			emit_signal("got_key")
			clear_tile_of_type(target_loc, "Key")
		
		if check_tile_type(my_loc, "ExitDoor") == true:
			emit_signal("level_complete")


# Moves the character during rotations
func instant_move(loc: Vector2i):
	my_loc = loc
	target_loc = loc
	self.position = Vector2(loc.x * tile_size + offset, loc.y * tile_size + offset)
