extends Node


@export var fight_button: Button
@export var label: Label
var args: PackedStringArray
@export var level_spawner: MultiplayerSpawner
@export var main_menu: Control
@export var reconnect_menu: Control
@export var players: Node
var is_connected_to_server: bool
var connection_timeout_timer: Timer


func _add_player(id: int = 1):
	var s = load("res://player.tscn") as PackedScene
	var i = s.instantiate()
	i.name = str(id)
	$Players.add_child(i, true)


func _notification(what):
	if OS.has_feature("mobile"):
		if what == MainLoop.NOTIFICATION_APPLICATION_FOCUS_OUT:
			if multiplayer.has_multiplayer_peer() and not is_multiplayer_authority():
				remove_multiplayer_peer()
		elif what == MainLoop.NOTIFICATION_APPLICATION_FOCUS_IN:
			if not multiplayer.has_multiplayer_peer() and is_connected_to_server:
				_start_client()


func _ready():
	reconnect_menu.hide()
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.server_disconnected.connect(_on_server_disconnected)
	multiplayer.connection_failed.connect(_on_connection_failed)
	fight_button.pressed.connect(_on_fight_pressed)
	connection_timeout_timer = Timer.new()
	connection_timeout_timer.timeout.connect(_on_connection_timeout)
	connection_timeout_timer.autostart = false
	connection_timeout_timer.wait_time = 3
	add_child(connection_timeout_timer, false, Node.INTERNAL_MODE_FRONT)
	
	args = OS.get_cmdline_args()
	if args.has("--s"):
		get_window().title = "server"
		_start_server()
	elif args.has("--d"):
		_start_client()


func _remove_player(id: int):
	$Players.find_child(str(id), false, false).queue_free()


func _on_connected_to_server():
	is_connected_to_server = true
	connection_timeout_timer.stop()
	main_menu.hide()
	reconnect_menu.hide()


func _on_connection_failed():
	main_menu.show()
	fight_button.disabled = false
	label.text = ""


func _on_connection_timeout():
	multiplayer.multiplayer_peer = null
	label.text = "Connection timed out. Retrying..."
	_start_client()


func _on_fight_pressed():
	fight_button.disabled = true
	_start_client()
	label.text = "Looking for match..."


func _on_peer_connected(id: int):
	if is_multiplayer_authority():
		_add_player(id)


func _on_peer_disconnected(id: int):
	if is_multiplayer_authority():
		_remove_player(id)


func _on_server_disconnected():
	is_connected_to_server = false
	reconnect_menu.show()
	_start_client()
	DebugOutput.w("server disconnected, reconnecting...")


func _start_client(ip: String = "20.ip.gl.ply.gg", port: int = 11314):
	if args.has("--l"):
		ip = "localhost"
		port = 4433
	var p = ENetMultiplayerPeer.new()
	var err = p.create_client(ip, port)
	if err == OK:
		multiplayer.multiplayer_peer = p
		reconnect_menu.hide()
		connection_timeout_timer.start()


func _start_server():
	main_menu.hide()
	var p = ENetMultiplayerPeer.new()
	p.peer_connected.connect(_on_peer_connected)
	p.peer_disconnected.connect(_on_peer_disconnected)
	p.create_server(4433)
	multiplayer.multiplayer_peer = p
	_add_player()
	change_level("lobby")


func change_level(level_name: String):
	for l in $Level.get_children():
		l.queue_free()
	
	var i = load("res://%s.tscn" % level_name).instantiate()
	$Level.add_child(i, true)


func disconnect_from_game():
	multiplayer.multiplayer_peer = null
	fight_button.disabled = false
	label.hide()
	main_menu.show()


func go_to_lobby():
	change_level("lobby")


func remove_multiplayer_peer():
	multiplayer.multiplayer_peer = null


func start_game():
	change_level("arena")
