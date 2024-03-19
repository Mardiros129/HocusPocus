extends Node2D

@onready var game_world = $GameWorld
@onready var character = $Character


func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			get_tree().quit()
