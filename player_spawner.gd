extends MultiplayerSpawner


@onready var player_scene: PackedScene = preload("res://player.tscn")


func spawn_player(id: int):
	var p = player_scene.instantiate()
	p.name = str(id)
	p.set_multiplayer_authority(id)
	get_node(spawn_path).add_child(p)
	return p
