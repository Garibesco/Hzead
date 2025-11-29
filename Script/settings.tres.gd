extends Control

signal back

func _on_start_pressed() -> void:
	emit_signal("back")
