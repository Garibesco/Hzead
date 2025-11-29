extends AnimatedSprite2D

@export var totem_id = 1
@export var note = 0
signal attuning_possible(totem_id)
signal attuning_impossible(totem_id)
signal is_attuned(totem_id)
var attuning = false
var attuned = false
var sintonized_played := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if note == 1:
		$sound.pitch_scale = 1.06
	play("idle")
	$Shockwave.visible = false
	$Shockwave.play("default")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if attuning:
		play("attuning")
		$Shockwave.visible = true
		if $attuning.is_stopped():
			$attuning.start()
		if note == 0:
			$AnimationTree.play("Tuning")
		else:
			$AnimationTree.play("Tuning_2")
	elif attuned:
		play("active")
		if not sintonized_played:
			$AnimationTree.play("sintonized")
			sintonized_played = true
	else:
		play("idle")
		$Shockwave.visible = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is not Player:
		return
	attuning_possible.emit(totem_id)
	#print("attuninig possible")

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is not Player:
		return
	attuning_impossible.emit(totem_id)
	#print("attuninig impossible")

func _on_attuning_timeout() -> void:
	attuned = true
	attuning = false
	is_attuned.emit(totem_id)
	if is_instance_valid($Area2D):
		$Area2D.queue_free()

func attuning_stopped():
	attuning = false
	
func set_attuning(x: bool):
	#print("TOTEM: set_attuning(", x, ") chiamato")
	if !attuned:
		attuning = x


func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name == "sintonized":
		$AnimationTree.stop(true)
