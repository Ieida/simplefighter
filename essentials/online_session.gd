extends CanvasLayer


var args: PackedStringArray


func _ready():
	args = OS.get_cmdline_args()
	if args.has("--s"):
		_start_server()
	else:
		_start_client()


func _start_client():
	var p = ENetMultiplayerPeer.new()
	var e = p.create_client("localhost", 4433)
	if e == OK:
		multiplayer.multiplayer_peer = p
	else:
		DebugOutput.w_e("Error starting client")
		DebugOutput.w_e("ENetMultiplayerPeer.create_client() returned error code: %s" % e)


func _start_server():
	var p = ENetMultiplayerPeer.new()
	var e = p.create_server(4433)
	if e == OK:
		multiplayer.multiplayer_peer = p
	else:
		DebugOutput.w_e("Error starting server")
		DebugOutput.w_e("ENetMultiplayerPeer.create_server() returned error code: %s" % e)
