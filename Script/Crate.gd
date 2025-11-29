extends RigidBody2D

var moving = false
var move_dir = 0.0
var move_timer = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta):
	if moving:
		$Node/AnimatedSprite2D.play("moving")
		linear_velocity.x = move_dir
		move_timer -= delta

		if move_timer <= 0:
			moving = false
			linear_velocity = Vector2.ZERO
	else:
		$Node/AnimatedSprite2D.play("idle")

func start_moving():
	if $dx.is_colliding():
		move_dir = -150
	elif $sx.is_colliding():
		move_dir = 150
	else:
		move_dir = 0      
	moving = true
	move_timer = 1.0

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is Bullet:
		if area.type == "low":
			start_moving()
			
		area.queue_free()
