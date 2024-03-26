extends CharacterBody2D

@onready var location = [0, 0]

@export var tile_size = 64
@onready var offset

func _ready():
	offset = tile_size / 2
	location[0] = (position.x - offset) / tile_size
	location[1] = (position.y - offset) / tile_size

func _input(event):
	if event.is_action_pressed("move_right"):
		location[0] += 1
	if event.is_action_pressed("move_left"):
		location[0] -= 1
	if event.is_action_pressed("move_up"):
		location[1] -= 1
	if event.is_action_pressed("move_down"):
		location[1] += 1

	self.position = Vector2(location[0] * tile_size + offset, location[1] * tile_size + offset)
