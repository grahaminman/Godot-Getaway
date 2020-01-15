extends Control

onready var NameTextBox = $VBoxContainer/CenterContainer/GridContainer/NameTextBox

func _ready():
	NameTextBox.text = Saved.save_data["Player_name"]

func _on_HostButton_pressed() -> void:
	Network.create_server()



func _on_JoinButton_pressed() -> void:
	Network.connect_to_server()


func _on_NameTextBox_text_changed(new_text: String) -> void:
	Saved.save_data["Player_name"] = NameTextBox.text
	Saved.save_game()
