extends Node3D

@export var player_scene : PackedScene

func add_player(id: int):
	var player = player_scene.instantiate()
	player.name = str(id)
	print("a player just joined the game and their id is:",player.name)
	add_child.call_deferred(player, true)
