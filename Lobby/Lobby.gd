extends Control

func _on_HostButton_pressed() -> void:
	Network.create_server()



func _on_JoinButton_pressed() -> void:
	Network.connect_to_server()
