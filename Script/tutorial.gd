extends Node2D

var player_scene = preload("res://Scene/Player.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Player/AnimationPlayer.play("fadein")
	$Player/Music/melody.volume_db = -80
	$Player/Music/high.volume_db = -80
	$Player.set_key(Array([0, 2, 3, 5, 7, 8, 10]))
	$Player.walkin()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass

func get_totem_by_id(id):
	for t in $TotemContainer.get_children():
		if t.totem_id == id:
			return t
	return null

func _on_jump_body_entered(body: Node2D) -> void:
	if body is not Player:
		return
	$Player/ControlSupport/Keyboard/Jump.show()
	$Player/ControlSupport/Playstation/Jump.show()
	$Player/ControlSupport/Xbox/Jump.show()
	#print("aoooo")


func _on_jump_body_exited(body: Node2D) -> void:
	if body is not Player:
		return
	$Player/ControlSupport/Keyboard/Jump.hide()
	$Player/ControlSupport/Playstation/Jump.hide()
	$Player/ControlSupport/Xbox/Jump.hide()
	#print("aoooo")

func _on_light_body_entered(body: Node2D) -> void:
	if body is not Player:
		return
	$Player/ControlSupport/Keyboard/Light.show()
	$Player/ControlSupport/Playstation/Light.show()
	$Player/ControlSupport/Xbox/Light.show()
	#print("aoooo")

func _on_light_body_exited(body: Node2D) -> void:
	if body is not Player:
		return
	$Player/ControlSupport/Keyboard/Light.hide()
	$Player/ControlSupport/Playstation/Light.hide()
	$Player/ControlSupport/Xbox/Light.hide()
	#print("aoooo")

func _on_heavy_body_entered(body: Node2D) -> void: 
	if body is not Player:
		return
	$Player/ControlSupport/Keyboard/Heavy.show()
	$Player/ControlSupport/Playstation/Heavy.show()
	$Player/ControlSupport/Xbox/Heavy.show()
	#print("aoooo")

func _on_heavy_body_exited(body: Node2D) -> void: 
	if body is not Player:
		return
	$Player/ControlSupport/Keyboard/Heavy.hide()
	$Player/ControlSupport/Playstation/Heavy.hide()
	$Player/ControlSupport/Xbox/Heavy.hide()
	#print("aoooo")

func _on_down_heavy_body_entered(body: Node2D) -> void:
	if body is not Player:
		return
	$Player/ControlSupport/Keyboard/Down_Heavy.show()
	$Player/ControlSupport/Playstation/Down_Heavy.show()
	$Player/ControlSupport/Xbox/Down_Heavy.show()
	#print("aoooo")

func _on_down_heavy_body_exited(body: Node2D) -> void:
	if body is not Player:
		return
	$Player/ControlSupport/Keyboard/Down_Heavy.hide()
	$Player/ControlSupport/Playstation/Down_Heavy.hide()
	$Player/ControlSupport/Xbox/Down_Heavy.hide()
	#print("aoooo")

func _on_attune_body_entered(body: Node2D) -> void:
	if body is Player:
		$Player/ControlSupport/Keyboard/Attune.show()
		$Player/ControlSupport/Playstation/Attune.show()
		$Player/ControlSupport/Xbox/Attune.show()
	#print("aoooo")

func _on_attune_body_exited(body: Node2D) -> void:
	if body is not Player:
		return
	$Player/ControlSupport/Keyboard/Attune.hide()
	$Player/ControlSupport/Playstation/Attune.hide()
	$Player/ControlSupport/Xbox/Attune.hide()
	#print("aoooo")

func _on_player_is_attuning(totem_id) -> void:
	#print("LIVELLO: ricevuto segnale dal player, attivo il totem")
	var totem = get_totem_by_id(totem_id)
	if totem:
		totem.set_attuning(true)

func _on_player_stop_attuning(totem_id) -> void:
	var totem = get_totem_by_id(totem_id)
	if totem:
		totem.attuning_stopped()

func _on_totem_attuning_possible(totem_id) -> void:
	var totem = get_totem_by_id(totem_id)
	if totem:
		$Player.set_attune(true, totem_id)


func _on_totem_attuning_impossible(totem_id: int) -> void:
	var totem = get_totem_by_id(totem_id)
	if totem:
		$Player.set_attune(false, totem_id)

func _on_totem_is_attuned(totem_id: int) -> void:
	var totem = get_totem_by_id(totem_id)
	if totem:
		$attune/CollisionShape2D.disabled = true
		$Player/AnimationPlayer.play("music_fadein")
		$Door.attuning_happened()

func _on_door_door_activated() -> void:
	await get_tree().create_timer(1).timeout
	$attune2/CollisionShape2D.disabled = false

func _on_door_attuning_impossible() -> void:
	$Player.set_attune_door(false)

func _on_door_attuning_possible() -> void:
	$Player.set_attune_door(true)

func _on_player_is_attuning_door() -> void:
	$Door/Shockwave.visible= true
	$Player/AnimationPlayer.play("fadeout")
	for totem in $TotemContainer.get_children():
		if is_instance_valid(totem):
			var anim_tree = totem.get_node_or_null("AnimationTree")
			if anim_tree:
				anim_tree.play("new_animation")
	$Door/AudioStreamPlayer2D.play()
	await get_tree().create_timer(4).timeout
	await get_tree().process_frame
	await get_tree().process_frame
	get_tree().change_scene_to_file("res://Scene/level.tscn")	

func _on_totem_2_attuning_impossible(totem_id) -> void:
	var totem = get_totem_by_id(totem_id)
	if totem:
		$Player.set_attune(false, totem_id)

func _on_totem_2_attuning_possible(totem_id) -> void:
	var totem = get_totem_by_id(totem_id)
	if totem:
		$Player.set_attune(true, totem_id)

func _on_totem_2_is_attuned(totem_id) -> void:
	var totem = get_totem_by_id(totem_id)
	if totem:
		$attune/CollisionShape2D.disabled = true
		$Player/AnimationPlayer.play("music_fadein_high")
		$Door.attuning_happened()

func _on_player_death() -> void:
	$Player/AnimationPlayer.play("fadeout")
	await get_tree().create_timer(2).timeout
	get_tree().reload_current_scene()
