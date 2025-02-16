extends Area2D

@export var layer_name: String
@onready var layer_number

@onready var quadrant0: Array[Vector2i]
@onready var quadrant1: Array[Vector2i]
@onready var quadrant2: Array[Vector2i]
@onready var quadrant3: Array[Vector2i]

@onready var can_rotate = false

signal rotate(quadrant0: Array[Vector2i], quadrant1: Array[Vector2i], quadrant2: Array[Vector2i], quadrant3: Array[Vector2i], go_right:bool)
signal test(name: String)

func _ready():
	if layer_name == "":
		print("Rotator is missing a name!")
	emit_signal("get_quadrants", layer_name, self)

func _process(delta):
	if Input.is_action_just_pressed("rotate_left"):
		emit_signal("rotate", quadrant0, quadrant1, quadrant2, quadrant3, false)
		emit_signal("test", layer_name)
	elif Input.is_action_just_pressed("rotate_right"):
		emit_signal("rotate", quadrant0, quadrant1, quadrant2, quadrant3, true)
		emit_signal("test", layer_name)
