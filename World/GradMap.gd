extends GridMap

const N = 1
const E = 2
const S = 4
const W = 8

var width = 20
var height = 20
var spacing = 2

func _ready() -> void:
	clear()
	make_map()


func make_map():
	for x in width:
		for z in height:
			var cell = randi() % 15
			set_cell_item(x, 0, z, cell)