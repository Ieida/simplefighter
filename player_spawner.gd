extends MultiplayerSpawner


@onready var player_scene: PackedScene = preload("res://player.tscn")
@onready var parent: Node = $"../Players"


func spawn_player(id: int):
	var p = player_scene.instantiate()
	p.name = str(id)
	parent.add_child(p, true)
	return p
