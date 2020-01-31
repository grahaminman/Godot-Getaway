extends Camera

onready var car = get_node("../../../../../..")

var minimum_height = 50
var speed = 0

func _physics_process(delta: float) -> void:
	var height = speed * 2 + minimum_height
	translation = Vector3(car.translation.x, height, car.translation.z)

func update_speed(new_speed):
	speed = new_speed
