extends CSGBox

func _ready():
	var selected_material = pick_random_material()
	material = load(selected_material)

func pick_random_material():
	var materials_list = get_files("res://Props/Billboards/BillboardMaterial/")
	var selected_material = materials_list[randi() % materials_list.size()]
	return selected_material

func get_files(folder):
	var gathered_files = {}
	var file_count = 0
	var dir = Directory.new()
	
	dir.open(folder)
	dir.list_dir_begin()
	
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			gathered_files[file_count] = folder + file
			file_count += 1
			
	return gathered_files
	