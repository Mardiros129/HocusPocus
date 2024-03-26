extends Area2D

@export var layer_name: String
@onready var layer_number

@onready var quadrant0: Array
@onready var quadrant1: Array
@onready var quadrant2: Array
@onready var quadrant3: Array

@onready var can_rotate = false

signal get_quadrants(layer: String, rotator: Area2D)
signal rotate(quadrant0: Array[Vector2i], quadrant1: Array[Vector2i], quadrant2: Array[Vector2i], quadrant3: Array[Vector2i], go_right:bool)


func _ready():
	if layer_name == "":
		print("Rotator is missing a name!")
	emit_signal("get_quadrants", layer_name, self)

func _process(delta):
	if can_rotate:
		if Input.is_action_just_pressed("rotate_left"):
			emit_signal("rotate", quadrant0, quadrant1, quadrant2, quadrant3, false)
		elif Input.is_action_just_pressed("rotate_right"):
			emit_signal("rotate", quadrant0, quadrant1, quadrant2, quadrant3, true)

func _on_area_entered(area):
	print("Player entered.")
	can_rotate = true

func _on_area_exited(area):
	can_rotate = false
