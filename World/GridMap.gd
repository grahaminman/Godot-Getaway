extends GridMap

const N = 1
const E = 2
const S = 4
const W = 8

var width = 20
var height = 20
var spacing = 2

var erase_fraction = 0.20

var cell_walls = {Vector3(0,0,-spacing) : N, Vector3(spacing,0,0): E,
		Vector3(0,0,spacing): S, Vector3(-spacing,0,0): W}

var plaza_tiles = [17,20,22,25]
var cafe_spots = []

func _ready() -> void:
	clear()
	if Network.local_player_id == 1:
		randomize()
		make_map_border()
		make_map()
		record_tile_positions()
		rpc("send_ready")

func make_map_border():
	$Border.resize_border(cell_size.x, width)

func make_map():
	make_blank_map()
	make_maze()
	erase_walls()

func make_blank_map():
	for x in width:
		for z in height:
			var possible_rotations = [0,10,16,22]
			var building_rotation = possible_rotations[randi() % 4]
			var building = pick_building(x,z)
			rpc("place_cell",x,z,building,building_rotation)


func pick_building(x,z):
	var chance_of_skyscraper = 1
	var skyscraper = 16
	var neighbourhood_1 = [17, 18, 19]
	var neighbourhood_2 = [20, 21]
	var neighbourhood_3 = [22, 23, 24]
	var neighbourhood_4 = [25, 26, 27]
	
	var possible_buildings
	
	if x >= width/2 and z >= height/2:
		possible_buildings = neighbourhood_2
	elif x >= width/2 and z <= height/2:
		possible_buildings = neighbourhood_3
	elif x <= width/2 and z >= height/2:
		possible_buildings = neighbourhood_4
	else:
		possible_buildings = neighbourhood_1
		
	var building
	if (randi() % 99) +1 <= chance_of_skyscraper:
		building = skyscraper
	else:
		 building = possible_buildings[randi() % possible_buildings.size() -1]
	return building


func check_neighbours(cell, unvisited):
	var list = []
	for n in cell_walls.keys():
		if cell+n in unvisited:
			list.append(cell+n)
	return list
	
func make_maze():
	var unvisited = []
	var stack = []

	for x in range(0, width, spacing):
		for z in range(0, height, spacing):
			unvisited.append( Vector3(x,0,z) )
	
	var current = Vector3(0,0,0)
	unvisited.erase(current)

	while unvisited:
		var neighbours = check_neighbours(current, unvisited)

		if neighbours.size() > 0:
			var next
			if current == Vector3(0,0,0):
				next = Vector3(0,0,spacing)
			else:
				next = neighbours[randi() % neighbours.size()]
			stack.append(current)

			var dir = next - current
			
			var current_walls = min(get_cell_item(current.x, 0, current.z),15) - cell_walls[dir]
			var next_walls = min(get_cell_item(next.x, 0, next.z),15) - cell_walls[-dir]
			
			rpc("place_cell", current.x, current.z, current_walls, 0)
			rpc("place_cell", next.x, next.z, next_walls, 0)
			fill_gaps(current, dir)
			current = next
			unvisited.erase(current)
		elif stack:
			current = stack.pop_back()


func fill_gaps(current, dir):
	var tile_type
	for i in range(1, spacing):
		if dir.x > 0:
			tile_type = 5
			current.x += 1
		elif dir.x < 0:
			tile_type = 5
			current.x -= 1
		elif dir.z > 0:
			tile_type = 10
			current.z += 1
		elif dir.z <0:
			tile_type = 10
			current.z -= 1
		rpc("place_cell", current.x, current.z, tile_type, 0)


func erase_walls():
	for i in range(width * height * erase_fraction):
		var x = int(rand_range(1, (width -1)/spacing )) * spacing
		var z = int(rand_range(1, (height -1)/spacing)) * spacing
		var cell = Vector3(x,0,z)
		var current_cell = get_cell_item(cell.x, cell.y, cell.z)
		var neighbour = cell_walls.keys()[randi() % cell_walls.size()]

		if current_cell & cell_walls[neighbour]:
			var walls = current_cell - cell_walls[neighbour]
			walls = clamp(walls, 0, 15)
			var neighbour_walls = get_cell_item( (cell + neighbour).x, 0,
					(cell + neighbour).z) - cell_walls[-neighbour]
			neighbour_walls = clamp(neighbour_walls,0,15)
			rpc("place_cell", cell.x, cell.z, walls, 0)
			rpc("place_cell", (cell + neighbour).x, (cell + neighbour).z, neighbour_walls, 0)
			fill_gaps(cell, neighbour)


sync func place_cell(x,z,cell,cell_rotation):
	set_cell_item(x,0,z,cell,cell_rotation)

func record_tile_positions():
	var tiles = []
	for x in range(0, width):
		for z in range(0, height):
			var current_cell = Vector3(x,0,z)
			var current_tile_type = get_cell_item(current_cell.x, 0, current_cell.z)
			if current_tile_type < 15:
				tiles.append(current_cell)
			elif current_tile_type in plaza_tiles:
				var building_rotation = get_cell_item_orientation(current_cell.x, 0, current_cell.z)
				var plaza_location = [building_rotation, x,z]
				cafe_spots.append(plaza_location)
	var map_size = Vector2(width, height)
	$ObjectSpawner.generate_props(tiles, map_size, cafe_spots)


sync func send_ready():
	if Network.local_player_id == 1: 
		player_ready()
	else:
		rpc_id(1,"player_ready")

remote func player_ready():
	Network.ready_players += 1
	if Network.ready_players == Network.players.size():
		rpc("send_go")

sync func send_go():
	get_tree().call_group("gamestate","unpause")









