class_name Hitbox extends Area2D


signal took_damage
signal health_depleted


@export var health: int = 100
@onready var max_health = health


func take_damage(amount: int):
	if not is_multiplayer_authority(): return
	_take_damage.rpc(amount)


@rpc("authority", "call_local", "reliable")
func _take_damage(amount: int):
	if health <= 0: return
	
	health -= amount
	took_damage.emit()
	if health <= 0:
		health = 0
		health_depleted.emit()
