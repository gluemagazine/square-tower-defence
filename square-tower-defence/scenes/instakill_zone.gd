extends Area2D



func _on_area_entered(area: Area2D) -> void:
	if area is HitboxComponent:
		if area.get_parent() is Enemy:
			area.get_parent().die()
