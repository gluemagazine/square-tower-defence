extends Node2D
class_name Base

@export var hitbox : HitboxComponent
@export var player_manager : PlayerManager

func _on_hitbox_component_body_entered(body: Node2D) -> void:
	if body is Enemy:
		var attack = Attack.new()
		attack.damage = body.stats.damage
		hitbox.damage(attack)
		body.queue_free()
		player_manager.damage(attack)
