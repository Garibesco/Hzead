extends Node2D

var button_type

func _ready() -> void:
	$InputManager.device_changed.connect(_on_inputmanager_device_changed)
	$Fade.show()
	$Fade/AnimationPlayer.play("fadein")
	await get_tree().create_timer(1).timeout
	$Fade.hide()

func _on_start_pressed() -> void:
	$Main/ButtonManager/MarginContainer/VBoxContainer.queue_free()
	$start.play()
	$theme.stop()
	$Fade.show()
	$Fade/AnimationPlayer.play("fadeout")
	await get_tree().create_timer(5).timeout
	await get_tree().process_frame
	var path = "res://Scene/tutorial.tscn"
	var scene = load(path)
	if scene:
		get_tree().change_scene_to_file(path)
	else:
		get_tree().quit()


func _on_options_pressed() -> void:
	$Fade.show()
	$Fade/AnimationPlayer.play("quickfadeout")
	await get_tree().create_timer(0.5).timeout
	$Main.hide()
	$Options.show()
	$Fade/AnimationPlayer.play("quickfadein")
	await get_tree().create_timer(0.5).timeout

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://Scene/GodotCredits.tscn")

func _on_start_focus_exited() -> void:
	$Selection.play()

func _on_options_focus_exited() -> void:
	$Selection.play()

func _on_credits_focus_exited() -> void:
	$Selection.play()

func _on_quit_focus_exited() -> void:
	$Selection.play()

func _on_texture_button_pressed() -> void:
	$Fade.show()
	$Fade/AnimationPlayer.play("quickfadeout")
	await get_tree().create_timer(0.5).timeout
	$Options.hide()
	$Main.show()
	$Main/ButtonManager/MarginContainer/VBoxContainer/Options.grab_focus()
	$Fade/AnimationPlayer.play("quickfadein")
	await get_tree().create_timer(0.5).timeout

func _on_inputmanager_device_changed(new_type: int) -> void:
	var input_manager = $InputManager
	match new_type:
		input_manager.InputType.KEYBOARD:
			$Options/xbox.hide()
			$Options/ps5.hide()
			$Options/keyboard.show()
		input_manager.InputType.XBOX:
			$Options/xbox.show()
			$Options/ps5.hide()
			$Options/keyboard.hide()
		input_manager.InputType.PLAYSTATION:
			$Options/xbox.hide()
			$Options/ps5.show()
			$Options/keyboard.hide()
		_:
			$Options/xbox.show()
			$Options/ps5.hide()
			$Options/keyboard.hide()

func _on_texture_button_focus_exited() -> void:
	$Selection.play()
