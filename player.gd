class_name Player extends Node


func _enter_tree():
	set_multiplayer_authority(int(str(name)))
