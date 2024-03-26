extends TileMap


@export var map_size: int
@onready var player_location: Vector2i

#### Note using yet
func _ready():
	# Get the player location. Magic number, change later.
	for x in map_size:
		for y in map_size:
			var my_tile = get_cell_tile_data(0, Vector2i(x, y), false)
			if my_tile != null:
				if my_tile.get_custom_data("Player") == true:
					player_location = Vector2i(x, y)
					print(str(x) + " " + str(y))
					break
