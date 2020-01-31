extends Spatial

func _enter_tree():
	get_tree().paused = true

func _ready() -> void:
	pass


func spawn_local_player():
	var new_player = preload("res://Player/Player.tscn").instance()
	new_player.name = str(Network.local_player_id)
	new_player.translation = Vector3(15,3,13)
	$Players.add_child(new_player)


remote func spawn_remote_player(id):
	var new_player = preload("res://Player/Player.tscn").instance()
	new_player.translation = Vector3(12,3,13)
	new_player.name = str(id)
	$Players.add_child(new_player)


func unpause():
	get_tree().paused = false
	spawn_local_player()
	rpc("spawn_remote_player", Network.local_player_id)
