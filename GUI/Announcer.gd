extends CenterContainer

func announce():
	$AnimationPlayer.stop(true)
	$AnimationPlayer.play("Announcement")


func money_stashed(player, money):
	rpc("announce_money", player, money)


sync func announce_money(player, money):
	$Label.text = "$£" + str(money) + " has been stashed by " + player
	announce()

sync func announce_crime(location):
	var x = stepify(location.x, 1)
	var z = stepify(location.z, 1)
	$Label.text = "Crime in progress at " + str(x) + " , " + str(z)
	announce()
	get_tree().call_group("Arrow", "new_destination", location)


func victory(criminals_win):
	rpc("announce_victory", criminals_win)


sync func announce_victory(criminals_win):
	if criminals_win:
		$Label.text = "Criminals Win! Crime Pays!"
		announce()
	else:
		$Label.text = "Cops win! Order is restored."
