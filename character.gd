extends CharacterBody2D

#var SPEED = 400
@onready var location = [32, 32]
@onready var tile_size = 64

func _input(event):
	if event.is_action_pressed("move_right"):
		location[0] += tile_size
	if event.is_action_pressed("move_left"):
		location[0] -= tile_size
	if event.is_action_pressed("move_up"):
		location[1] -= tile_size
	if event.is_action_pressed("move_down"):
		location[1] += tile_size

	self.position = Vector2(location[0], location[1])

#func _physics_process(delta):
	#var direction_x = Input.get_axis("ui_left", "ui_right")
	#if direction_x:
		#velocity.x = direction_x * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
#
	#var direction_y = Input.get_axis("ui_up", "ui_down")
	#if direction_y:
		#velocity.y = direction_y * SPEED
	#else:
		#velocity.y = move_toward(velocity.y, 0, SPEED)
#
	#move_and_slide()
#
#func set_location(my_location):
	#location = my_location
