extends TextureRect

var currentBase


func _on_close_pressed() -> void:
	currentBase = null
	visible = false
