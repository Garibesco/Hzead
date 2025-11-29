extends Node2D
@export var attuning_need = 1
var attuned = 0
@export var active = false
signal door_activated
signal attuning_possible
signal attuning_impossible
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play("default")
	$Shockwave.play("default")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if active:
		$AnimatedSprite2D.play("active")
	else:
		$AnimatedSprite2D.play("default")

func attuning_happened():
	attuned += 1
	if attuned == attuning_need:
		$AnimationPlayer.play("attuning")
		door_activated.emit()
		#$AudioStreamPlayer2D.play()

func _on_area_2d_body_entered(body: Node2D) -> void:
	attuning_possible.emit()


func _on_area_2d_body_exited(body: Node2D) -> void:
	attuning_impossible.emit()
