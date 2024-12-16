extends MultiplayerSpawner


@onready var parent: Node = $"../Level"


func change_level(to: int):
	for c in parent.get_children():
		if c == self: continue
		parent.remove_child(c)
		c.queue_free()
	
	var s = load(get_spawnable_scene(to)) as PackedScene
	var i = s.instantiate()
	parent.add_child(i, true)


func unload_all_levels():
	for c in parent.get_children():
		if c == self: continue
		
		parent.remove_child(c)
		c.queue_free()
