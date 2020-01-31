extends Spatial

func resize_border(tile_size, tile_count):
	rpc("make_border", tile_size, tile_count)


sync func make_border(tile_size, tile_count):
	var wall_size = tile_size * tile_count
	$N_Wall.translation = Vector3(wall_size/2, $N_Wall.height/2, -1)
	$S_Wall.translation = Vector3(wall_size/2, $S_Wall.height/2, wall_size+1)
	$W_Wall.translation = Vector3(-1, $W_Wall.height/2, wall_size/2)
	$E_Wall.translation = Vector3(wall_size+1, $E_Wall.height/2, wall_size/2)
	for child in get_children():
		child.width = wall_size + 2
		child.use_collision = true
