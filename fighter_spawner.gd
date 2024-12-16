extends MultiplayerSpawner


var players: Node
@onready var fighters: Node = $"../Fighters"


func _on_fighter_died():
	if is_multiplayer_authority():
		await get_tree().create_timer(3).timeout
		respawn_fighters()


func _on_player_entered(_player: Node):
	pass


func _on_player_exiting(_player: Node):
	var i = _player.get_index()
	fighters.get_child(i).queue_free()


func _ready():
	players = get_node("/root/Multiplayer/Players")
	players.child_entered_tree.connect(_on_player_entered)
	players.child_exiting_tree.connect(_on_player_exiting)
	if is_multiplayer_authority():
		spawn_fighters()


func despawn_fighters():
	for f in fighters.get_children():
		if f == self: continue
		
		f.queue_free()


func respawn_fighters():
	if is_multiplayer_authority():
		despawn_fighters()
		spawn_fighters()


func spawn_fighter(id: int, pos: Vector2):
	var s = load(get_spawnable_scene(0)) as PackedScene
	var f = s.instantiate()
	f.name = str(id)
	f.global_position = pos
	fighters.add_child(f)
	return f


func spawn_fighters():
	if is_multiplayer_authority():
		var p1 = players.get_child(0)
		var p2 = players.get_child(1)
		var sp1 = get_child(0).global_position
		var sp2 = get_child(1).global_position
		var f1 = spawn_fighter(p1.get_multiplayer_authority(), sp1)
		var f2 = spawn_fighter(p2.get_multiplayer_authority(), sp2)
		f1.died.connect(_on_fighter_died)
		f2.died.connect(_on_fighter_died)
