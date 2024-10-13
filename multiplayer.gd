extends Node


@onready var fight_button: Button = $MainMenu/VBoxContainer/Fight
@onready var label: Label = $MainMenu/VBoxContainer/Label
var args: PackedStringArray
@onready var level_spawner: MultiplayerSpawner = $LevelSpawner
@onready var player_spawner: MultiplayerSpawner = $PlayerSpawner
@onready var main_menu: Control = $MainMenu
var players: Array[Player]


func _add_player(id: int = 1):
	var p = player_spawner.spawn_player(id)
	players.append(p)
	if args.has("--d") and players.size() > 1:
		start_game()


func _ready():
	label.hide()
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	fight_button.pressed.connect(_on_fight_pressed)
	
	args = OS.get_cmdline_args()
	if args.has("--server"):
		call_deferred("_start_server")
		get_window().title = "server"
	elif args.has("--d"):
		call_deferred("_start_client")


func _on_connected_to_server():
	main_menu.hide()


func _on_fight_pressed():
	fight_button.disabled = true


func _start_client():
	var p = ENetMultiplayerPeer.new()
	p.create_client("localhost", 4433)
	multiplayer.multiplayer_peer = p
	fight_button.disabled = true
	label.show()


func _start_server():
	main_menu.hide()
	level_spawner.change_level.call_deferred(0)
	var p = ENetMultiplayerPeer.new()
	p.peer_connected.connect(_on_peer_connected)
	p.create_server(4433)
	multiplayer.multiplayer_peer = p
	_add_player()


func start_game():
	level_spawner.change_level(1)


func _on_peer_connected(id: int):
	print("peer with id %s connected" % id)
	_add_player(id)
