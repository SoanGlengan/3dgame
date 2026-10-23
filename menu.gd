extends Control

var playerName = {"name": "Name"}
var port
var ip = "127.0.0.1"
func _ready() -> void:
	multiplayer.peer_connected.connect(add_player)

func _on_name_text_submitted(new_text: String) -> void:
	playerName = {"name": new_text}
	print(playerName)


func _on_host_pressed() -> void:
	Server.player_info = {"name": playerName}
	Server.create_game()
	Server._register_player(playerName)

func add_player():
	pass
