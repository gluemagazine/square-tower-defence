extends Node2D
class_name Base

@export var hitbox : HitboxComponent
@onready var panel: AnimatedPanel = $AnimatedPanel

func _ready() -> void:
	panel.stop()

func _on_hitbox_component_body_entered(body: Node2D) -> void:
	if body is Enemy:
		var attack = Attack.new()
		attack.damage = body.stats.damage
		hitbox.damage(attack)
		body.queue_free()
		Game.manager.damage(attack)
		panel.play_on_top("hurt")
