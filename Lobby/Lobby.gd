extends CanvasLayer

onready var NameTextBox = $VBoxContainer/CenterContainer/GridContainer/NameTextBox
onready var port = $VBoxContainer/CenterContainer/GridContainer/PortTextBox
onready var selected_IP = $VBoxContainer/CenterContainer/GridContainer/IPTextBox

var is_cop = false

func _ready():
	NameTextBox.text = Saved.save_data["Player_name"]
	selected_IP.text = Network.DEFAULT_IP
	port.text = str(Network.DEFAULT_PORT)


func _on_HostButton_pressed() -> void:
	Network.selected_port = int(port.text)
	Network.is_cop = is_cop
	Network.create_server()
	get_tree().call_group("HostOnly", "show" )
	create_waiting_room()

func _on_JoinButton_pressed() -> void:
	Network.selected_port = int(port.text)
	Network.selected_IP = selected_IP.text
	Network.is_cop = is_cop
	Network.connect_to_server()
	create_waiting_room()

func _on_NameTextBox_text_changed(new_text: String) -> void:
	Saved.save_data["Player_name"] = NameTextBox.text
	Saved.save_game()


func create_waiting_room():
	$WaitingRoom.popup_centered()
	$WaitingRoom.refresh_players(Network.players)


func _on_ReadyButton_pressed() -> void:
	Network.start_game()


func _on_TeamCheck_toggled(button_pressed: bool) -> void:
	is_cop = button_pressed
