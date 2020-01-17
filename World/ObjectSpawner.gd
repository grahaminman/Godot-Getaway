extends Node

var tiles = []
var map_size = Vector2()

var number_of_parked_cars = 100

func generate_props(tile_list, size):
	tiles = tile_list
	map_size = size
	place_cars()

func random_tile(tile_count):
	var tile_list = tiles
	var selected_tiles = []
	tile_list.shuffle()
	for i in range(tile_count):
		var tile = tile_list[i]
		selected_tiles.append(tile)
	return selected_tiles
	
func place_cars():
	var tile_list = random_tile(number_of_parked_cars)
	for i in range(number_of_parked_cars):
		var tile = tile_list[0]
		var tile_type = get_node("..").get_cell_item(tile.x, 0, tile.z)
		var allowed_rotations = $ObjectRotLookup.lookup_rotation(tile_type)
		if not allowed_rotations == null:
			var tile_rotation = allowed_rotations[randi() % allowed_rotations.size() -1] *-1
			tile.y = tile.y+1 # adjust for the height of the cars
			rpc("spawn_cars", tile, tile_rotation)
		tile_list.pop_front()


sync func spawn_cars(tile, car_rotation):
	var car = preload("res://Props/ParkedCars.tscn").instance()
	car.translation = Vector3( (tile.x * 20) + 10, tile.y, (tile.z * 20)+10)
	car.rotation_degrees.y = car_rotation
	add_child(car, true)