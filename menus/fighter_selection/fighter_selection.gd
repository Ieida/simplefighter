extends PanelContainer


signal fighter_selected(idx: int)


@export var spawner: MultiplayerSpawner
@export var container: Container


func _ready():
	for si in spawner.get_spawnable_scene_count():
		var s = spawner.get_spawnable_scene(si) as String
		var ps = load(s.get_base_dir().path_join("preview.tscn")) as PackedScene
		var p = ps.instantiate() as Button
		p.pressed.connect(_on_button_pressed)
		container.add_child(p)


func _on_button_pressed():
	# Find pressed button
	var pb: Button = null
	for b in container.get_children():
		if b.button_pressed:
			pb = b
			break
	
	_fighter_selected.rpc_id(1, pb.get_index())


@rpc("any_peer", "call_local", "reliable")
func _fighter_selected(idx: int):
	pass
