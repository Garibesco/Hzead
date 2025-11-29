extends Node2D

@export var text = ""
@export var text2 = ""
@export var size = 0.6

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Node2D/Label.text = text
	$Node2D/Label2.text = text2
	$Node2D/Label.scale = Vector2(size, size)
	$Node2D/Label2.scale = Vector2(size, size)
	$Node2D.set_modulate(0)
	$AnimatedSprite2D.play("idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	$AnimationPlayer.play("fadeout")
	#$Node2D.set_modulate(1)

func _on_area_2d_body_exited(body: Node2D) -> void:
	$AnimationPlayer.play("fadein")
	#$Node2D.set_modulate(0)
