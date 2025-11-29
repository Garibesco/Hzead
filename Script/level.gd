extends Node2D

var player_scene = preload("res://Scene/Player.tscn")
var last_cooridnates 
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	$Player/AnimationPlayer.play("fadein")
	$Player.set_key(Array([1, 2, 4, 6, 8, 9, 11]))
	$Player/Music/high.volume_db = -80
	$Player/Music/middle.volume_db = -80
	$Player/Music/melody.volume_db = -80
	$Player.walkin()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_totem_by_id(id):
	for t in $TotemContainer.get_children():
		if t.totem_id == id:
			return t
	return null

func _on_area_2d_2_body_entered(body: Node2D) -> void:
	if body is Player:
		last_cooridnates = $Teleport/Area2D2/Teleport_check.coordinates

func _on_player_teleport() -> void:
	$Player/AnimationPlayer.play("quick_fadein_out")
	$Player.set_enmov(false)
	$Player/hurtbox.monitorable = false
	$Player.position = last_cooridnates
	await get_tree().create_timer(1).timeout
	$Player.set_enmov(true)
	$Player/hurtbox.monitorable = true

func _on_area_2d_3_body_entered(body: Node2D) -> void:
	if body is Player:
		last_cooridnates = $Teleport/Area2D3/Teleport_check.coordinates
		

func choose_fadeout():
	if $Player/Music/low.volume_db > -80 and $Player/Music/high.volume_db > -80 and $Player/Music/melody.volume_db > -80 and $Player/Music/middle.volume_db > -80:
		$Player/AnimationPlayer.play("music_fadeout_8")
		print(8)
	elif $Player/Music/low.volume_db > -80 and $Player/Music/high.volume_db > -80 and $Player/Music/melody.volume_db > -80:
		$Player/AnimationPlayer.play("music_fadeout_7")
		print(7)
	elif $Player/Music/low.volume_db > -80 and $Player/Music/middle.volume_db > -80 and $Player/Music/melody.volume_db > -80:
		$Player/AnimationPlayer.play("music_fadeout_6")
		print(6)
	elif $Player/Music/low.volume_db > -80 and $Player/Music/middle.volume_db > -80 and $Player/Music/high.volume_db > -80:
		$Player/AnimationPlayer.play("music_fadeout_5")
		print(5)
	elif $Player/Music/low.volume_db > -80 and $Player/Music/melody.volume_db > -80:
		$Player/AnimationPlayer.play("music_fadeout_4")
		print(4)
	elif $Player/Music/low.volume_db > -80 and $Player/Music/high.volume_db > -80:
		$Player/AnimationPlayer.play("music_fadeout_3")
		print(3)
	elif $Player/Music/low.volume_db > -80 and $Player/Music/middle.volume_db > -80:
		$Player/AnimationPlayer.play("music_fadeout_2")
		print(2)
	elif $Player/Music/low.volume_db > -80:
		print(1)
		$Player/AnimationPlayer.play("music_fadeout_1")

func _on_player_death() -> void:
	#print("ded")
	choose_fadeout()

	await get_tree().create_timer(3).timeout
	get_tree().reload_current_scene()

func _on_totem_attuning_possible(totem_id) -> void:
	var totem = get_totem_by_id(totem_id)
	if totem:
		$Player.set_attune(true, totem_id)

func _on_totem_attuning_impossible(totem_id: Variant) -> void:
	var totem = get_totem_by_id(totem_id)
	if totem:
		$Player.set_attune(false, totem_id)

func _on_player_is_attuning(totem_id) -> void:
	var totem = get_totem_by_id(totem_id)
	if totem:
		totem.set_attuning(true)

func _on_player_is_attuning_door() -> void:
	$Door/Shockwave.visible= true
	choose_fadeout()
	for totem in $TotemContainer.get_children():
		if is_instance_valid(totem):
			var anim_tree = totem.get_node_or_null("AnimationTree")
			if anim_tree:
				anim_tree.play("new_animation")
	$Door/AudioStreamPlayer2D.pitch_scale = 0.94
	$Door/AudioStreamPlayer2D.play()
	await get_tree().create_timer(4).timeout
	await get_tree().process_frame
	await get_tree().process_frame
	get_tree().change_scene_to_file("res://Scene/GodotCredits.tscn")

func _on_player_stop_attuning(totem_id) -> void:
	var totem = get_totem_by_id(totem_id)
	if totem:
		totem.attuning_stopped()

func _on_totem_is_attuned(totem_id: Variant) -> void:
	var totem = get_totem_by_id(totem_id)
	if totem:
		$Player/AnimationPlayer.play("music_fadein_middle")
		$block.queue_free()
		$Door.attuning_happened()

func _on_area_2d_5_body_entered(body: Node2D) -> void:
	if body is Player:
		last_cooridnates = $Teleport/Area2D5/Teleport_check.coordinates

func _on_area_2d_4_body_entered(body: Node2D) -> void:
	if body is Player:
		last_cooridnates = $Teleport/Area2D4/Teleport_check.coordinates

func _on_totem_2_attuning_impossible(totem_id: Variant) -> void:
	var totem = get_totem_by_id(totem_id)
	if totem:
		$Player.set_attune(false, totem_id)

func _on_totem_2_attuning_possible(totem_id: Variant) -> void:
	var totem = get_totem_by_id(totem_id)
	if totem:
		$Player.set_attune(true, totem_id)

func _on_totem_2_is_attuned(totem_id: Variant) -> void:
	var totem = get_totem_by_id(totem_id)
	if totem:
		$Player/AnimationPlayer.play("music_fadein_high")
		$block2.queue_free()
		$Door.attuning_happened()

func _on_area_2d_6_body_entered(body: Node2D) -> void:
		if body is Player:
			last_cooridnates = $Teleport/Area2D6/Teleport_check.coordinates

func _on_totem_3_attuning_impossible(totem_id: Variant) -> void:
	var totem = get_totem_by_id(totem_id)
	if totem:
		$Player.set_attune(false, totem_id)

func _on_totem_3_attuning_possible(totem_id: Variant) -> void:
	var totem = get_totem_by_id(totem_id)
	if totem:
		$Player.set_attune(true, totem_id)

func _on_totem_3_is_attuned(totem_id: Variant) -> void:
	var totem = get_totem_by_id(totem_id)
	if totem:
		$Player/AnimationPlayer.play("music_fadein")
		$Door.attuning_happened()

func _on_door_attuning_impossible() -> void:
	$Player.set_attune_door(false)

func _on_door_attuning_possible() -> void:
	$Player.set_attune_door(true)

func _on_door_door_activated() -> void:
	await get_tree().create_timer(1).timeout
	

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
			last_cooridnates = $Teleport/Area2D/Teleport_check.coordinates
