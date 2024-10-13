extends MultiplayerSpawner


@onready var level: Node = $"../Level"


func change_level(to: int):
	for c in level.get_children():
		level.remove_child(c)
		c.queue_free()
	
	var s = load(get_spawnable_scene(to)) as PackedScene
	level.add_child(s.instantiate())
