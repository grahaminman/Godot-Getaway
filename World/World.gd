extends Spatial

var money_stashed =  0
var money_recovered = 0

export var criminal_victory_score = 3000
export var cop_victory_score = 3000

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

remote func update_gamestate(stashed, recovered):
	if Network.local_player_id == 1:
		money_stashed += stashed
		money_recovered += recovered
		check_win_conditions()
	else:
		rpc_id(1, "update_gamestate", stashed, recovered)

func check_win_conditions():
	if money_stashed >= criminal_victory_score:
		get_tree().call_group("Announcements", "victory", true)
	elif money_recovered >= cop_victory_score:
		get_tree().call_group("Announcements", "victory", false)
		
	
