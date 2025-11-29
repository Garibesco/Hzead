extends Node2D
class_name Crystal
enum state {idle, resonate, shatter, reconstruct}
var current_state = state.idle
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if current_state == state.idle and $AnimatedSprite2D.animation != "idle":
		$AnimatedSprite2D.play("idle")
	elif current_state == state.shatter and  $AnimatedSprite2D.animation != "shatter":
		$AnimatedSprite2D.play("shatter")
	elif current_state == state.reconstruct and  $AnimatedSprite2D.animation != "rebuild":
		$AnimatedSprite2D.play("rebuild")
	elif current_state == state.resonate and  $AnimatedSprite2D.animation != "resonate":
		$AnimatedSprite2D.play("resonate")

func make_resonate():
	current_state = state.resonate
	$resonate.start()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is Bullet:
		if current_state == state.idle:
			if area.type == "low":
				current_state = state.resonate
				$resonate.start()
			elif area.type == "high":
				current_state = state.shatter
				$shatter.start()
		area.queue_free()

func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "shatter":
		visible = false
		$RigidBody2D/CollisionShape2D.disabled = true
		$Area2D/CollisionShape2D.disabled = true
	elif $AnimatedSprite2D.animation == "rebuild":
		current_state = state.idle
		$RigidBody2D/CollisionShape2D.disabled = false
		$Area2D/CollisionShape2D.disabled = false

func _on_resonate_timeout() -> void:
	current_state = state.idle


func _on_shatter_timeout() -> void:
	#print("shatter timeout")
	current_state = state.reconstruct
	visible = true
	

func _on_animated_sprite_2d_animation_changed() -> void:
	#print("animazione cambiata")
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		for child in body.get_children():
			if child is hurtbox and child.monitorable:
				var damage_dir = 0
				var hit_left  = $left_ray.is_colliding()  or $left_ray2.is_colliding()  or $left_ray3.is_colliding() or $up_ray.is_colliding()
				var hit_right = $right_ray.is_colliding() or $right_ray2.is_colliding() or $right_ray3.is_colliding()
				if hit_left:
					damage_dir = 1
				elif hit_right:
					damage_dir = -1
				else:
					damage_dir = 1  # fallback
				body.call_deferred("damage", damage_dir)
				break
