extends Control

var playerName
var port
var ip = "127.0.0.1"

func _on_name_text_submitted(new_text: String) -> void:
	playerName = new_text
	print(playerName)


func _on_host_pressed() -> void:
	Server.create_game()
	Server.load_game.rpc("game.tscn")
	Server.player_loaded()
