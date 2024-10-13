class_name Hurtbox extends Area2D


@export var root: Node
@export var damage: int = 100


func _ready():
	area_entered.connect(_on_area_entered)


func _on_area_entered(area: Area2D):
	if not area is Hitbox: return
	if root.is_ancestor_of(area): return
	
	area.take_damage(damage)
