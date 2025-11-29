extends CharacterBody2D
class_name Player

@export var speed = 425
@export var gravity = 981.0
@export var water_gravity = 490.0
@export var jump_force = 600
@export var jump_water = 450
@onready var bullet = preload("res://Scene/Bullet.tscn")
@onready var hearts = preload("res://Scene/heart.tscn")
var hf_attack_tex = preload("res://Asset/Character/HF_attack/HF_attack-01.png")
var hf_attack_tex2 = preload("res://Asset/Character/HF_attack/HF_attack-02.png")
var lf_attack_tex = preload("res://Asset/Character/LF_attack/LF_attack-01.png")
var lf_attack_tex2 = preload("res://Asset/Character/LF_attack/LF_attack-02.png")
@export var jump_buffer_timer: float = .1
@export var max_fall_speed := 1300.0
signal death
signal teleport
var hurt = false
var dead = false
var dead_player = false
var hearts_list : Array[TextureRect]
var health = 5
var max_healh = 5
var force_jump := false
var do_jump := false
var iswalkin = false
var attack_impulse = Vector2.ZERO
var input_enable = true
var movement_enable = true
var attacking = false
var kind_attack
var current_gravity = gravity
var jump_available
var jump_buffer = false
var sprite 
var direction
var can_attune
var attuning
var attuning_door
signal is_attuning
signal is_attuning_door
signal stop_attuning
var facing_direction := 1 
var totem_id


func _ready() -> void:
	set_health()
	velocity = Vector2.ZERO
	sprite = $AnimatedSprite2D
	sprite.play("idle")

func _physics_process(delta: float) -> void:
	if dead:
		if !dead_player:
			sprite.play("death")
			$Timer/death.start()
			$Death.play()
			dead_player = true
		return
	if iswalkin:
		velocity = Vector2.ZERO
		velocity.x += 200
		update_animation()
		move_and_slide()
	if hurt:
		update_animation()
		move_and_slide()
		return
	if !input_enable:
		if attacking:
			if kind_attack != 1:
				velocity = Vector2.ZERO
				velocity += attack_impulse
				attack_impulse = attack_impulse.move_toward(Vector2.ZERO, 150 * delta)
			velocity.y += (current_gravity*2.2) * delta
			if is_on_floor() and attacking and kind_attack == 1:
				attack_impulse = Vector2.ZERO
				input_enable = true
				attacking = false
				kind_attack = 0
			move_and_slide()
			return
		elif !movement_enable:
			velocity.x = (direction * speed) 
			return
		else:
			return
	else:
		direction = 0
		if Input.is_action_pressed("syntonize") and is_on_floor():# and velocity.y == 0 and velocity.x == 0:
			if $Timer/Attuning.is_stopped():
				$Timer/Attuning.start()
				attuning = true
		elif Input.is_action_just_released("syntonize"):
			if !$Timer/Attuning.is_stopped():
				$Timer/Attuning.stop()
			attuning = false
			stop_attuning.emit(totem_id)
		if attuning:
			velocity = Vector2.ZERO 
			update_animation()
			move_and_slide()
			return
		if Input.is_action_pressed("right"):
			direction += 1
		elif Input.is_action_pressed("left"):
			direction -= 1
		if direction != 0:
			facing_direction = direction
			sprite.flip_h = facing_direction < 0
		
		velocity.x = (direction * speed) 
		if direction != 0 and is_on_floor():
			play_steps()
		
		if Input.is_action_just_pressed("heavy") and Input.is_action_pressed("down"):
			d_heavy()
		elif Input.is_action_just_pressed("light") and !is_on_floor():
			light()
		elif Input.is_action_just_pressed("heavy") and is_on_floor():
			if not attacking:
				heavy()
		
		if not is_on_floor():
			if kind_attack == 3 and force_jump:
				force_jump = false 
			else:
				if !attacking and kind_attack != 1:
					if velocity.y < 0:
						velocity.y += current_gravity * delta
					else:
						velocity.y += (current_gravity*2.2) * delta
				jump_available = false
		else:
			jump_available = true
			if jump_buffer:
				jump()
				jump_buffer = false
		if Input.is_action_just_pressed("jump"):
				if jump_available:
					jump()
				else:
					jump_buffer = true
					get_tree().create_timer(jump_buffer_timer).timeout.connect(on_jump_buffer_timeout)
		if Input.is_action_just_released("jump") and velocity.y < 0:
			velocity.y = 0
		velocity += attack_impulse
		attack_impulse = attack_impulse.move_toward(Vector2.ZERO, 50 * delta)
	if do_jump:
		jump()
		do_jump = false
	update_animation()
	velocity.y = clamp(velocity.y, -INF, max_fall_speed)

	move_and_slide()


func update_animation():
	if sprite == null: return
	if attacking:
		match kind_attack:
			1: sprite.play("HF_attack")
			2: sprite.play("LF_attack")
			3: sprite.play("down_LF_attack")
		return
	if attuning:
		if can_attune:
			sprite.play("attuning")
		else:
			sprite.play("focus")
		return
	if hurt:
		sprite.play("fall")
		return
	if velocity.y < 0:
		sprite.play("jump")
	elif velocity.y > 0 and not is_on_floor():
		sprite.play("fall")
	elif abs(velocity.x) > 0 and not attacking:
		sprite.flip_h = velocity.x < 0
		sprite.play("walk")
	else:
		sprite.play("idle")
	
func light():
	$HighAttacks.play_track()
	var bullet_temp = bullet.instantiate()
	var dir
	if sprite.flip_h:
		dir = -1
	else:
		dir = 1
	bullet_temp.set_specs(dir, "high")
	bullet_temp._set_position(position.x, position.y)
	if current_gravity == water_gravity:
		bullet_temp.set_water(true)
	else:
		bullet_temp.set_water(false)
	get_parent().add_child(bullet_temp)
	kind_attack = 1
	attacking = true
	input_enable = false
	#attack_impulse = Vector2(-10 * facing_direction, 0)
	velocity.y = 0
	$Timer/light.start()
	#await get_tree().create_timer(0.6).timeout
	
	
func heavy():
	$LowAttacks.play_track()
	var bullet_temp = bullet.instantiate()
	var dir
	if sprite.flip_h:
		dir = -1
	else:
		dir = 1
	bullet_temp.set_specs(dir, "low")
	bullet_temp._set_position(position.x, position.y)
	if current_gravity == water_gravity:
		bullet_temp.set_water(true)
	else:
		bullet_temp.set_water(false)
	get_parent().add_child(bullet_temp)
	kind_attack = 2
	attacking = true
	input_enable = false
	attack_impulse = Vector2(-10 * facing_direction, 0)
	await get_tree().create_timer(0.6).timeout
	attack_impulse = Vector2.ZERO
	input_enable = true
	attacking = false
	kind_attack = 0
	
func d_heavy():
	$LowerAttacks.play_track()
	$wave.play("default")
	$wave.visible = true
	kind_attack = 3
	attacking = true
	input_enable = false
	$bounce/CollisionShape2D.disabled = false
	await get_tree().process_frame
	for body in $bounce.get_overlapping_bodies():
		call_deferred("_on_area_2d_body_entered", body)
	$Timer/Down_attack.start()
	jump_available = false
	
	$Timer/heavy_d.start()
	await get_tree().create_timer(0.3).timeout
	
	
func jump():
	$Jump.play_random()
	if current_gravity == gravity:
		velocity.y = -jump_force
	else:
		velocity.y = -jump_water
	jump_available = false
	
func set_attune(canhe: bool, id):
	can_attune = canhe
	totem_id = id
	
func set_attune_door(canhe: bool):
	attuning_door = canhe
	
func on_jump_buffer_timeout():
	jump_buffer = false
	
func set_gravity(new_gravity):
	if new_gravity == "normal":
		current_gravity = gravity
	elif new_gravity == "water":
		current_gravity = water_gravity
		
func get_gravity_player():
	return current_gravity
	
func walkin():
	iswalkin = true
	input_enable = false
	$Timer/Walkin.start()

func damage(dir):
	if hurt or dead:
		return
	if health > 0:
		hurt = true
	
		$hurtbox.set_deferred("monitorable", false)
		$Damage.play_random()
		$Timer/Hurt.start()
		health = health-1
		update_heart_display()
		if dir == 0:
			if health != 0:
				teleport.emit()
		else:
			velocity.y = -300
			velocity.x = 300 if dir == -1 else -300
	if health <= 0:
		dead = true
		
func update_heart_display():
	for i in range(hearts_list.size()):
		var heart = hearts_list[i]
		for child in heart.get_children():
			if child is AnimatedSprite2D:
				if i < health:
					child.play("up")  
				else:
					child.play("down")

func set_health():
	hearts_list = []
	var hearts_parent = $health_bar/HBoxContainer
	for i in range(0, health):
		var heart_instance = hearts.instantiate()
		hearts_parent.add_child(heart_instance)
		hearts_list.append(heart_instance)

func play_steps():
	if $Steps/Timer.is_stopped():
		$Steps.play_random()
		var rng = RandomNumberGenerator.new()
		var value = rng.randf_range(0.25, 0.6)
		$Steps/Timer.wait_time = value
		$Steps/Timer.start()

func set_enmov(can):
	input_enable = can

func set_parallax(which: int):
	print(which)

func set_key(key:Array):
	$LowAttacks.set_key(key)
	$HighAttacks.set_key(key)
	$LowerAttacks.set_key(key)

func _on_input_manager_device_changed(new_type: int) -> void:
	var input_manager = $ControlSupport/InputManager
	match new_type:
		input_manager.InputType.KEYBOARD:
			$ControlSupport/Xbox.hide()
			$ControlSupport/Playstation.hide()
			$ControlSupport/Keyboard.show()
		input_manager.InputType.XBOX:
			$ControlSupport/Xbox.show()
			$ControlSupport/Playstation.hide()
			$ControlSupport/Keyboard.hide()
		input_manager.InputType.PLAYSTATION:
			$ControlSupport/Xbox.hide()
			$ControlSupport/Playstation.show()
			$ControlSupport/Keyboard.hide()
		_:
			$ControlSupport/Xbox.show()
			$ControlSupport/Playstation.hide()
			$ControlSupport/Keyboard.hide()

func _on_attuning_timeout() -> void:
	if attuning and can_attune:
		is_attuning.emit(totem_id)
	if attuning and attuning_door:
		is_attuning_door.emit()

func _on_down_attack_timeout() -> void:
	$bounce/CollisionShape2D.disabled = true
	$wave.visible = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	#print("down! 1")
	if body.get_parent() is Crystal:
	#	print("down! 2")
		body.get_parent().make_resonate()
		force_jump = true
		do_jump = true
	#	print("func jump passed")

func _on_walkin_timeout() -> void:
	iswalkin = false 
	input_enable = true

func _on_hurt_timeout() -> void:
	hurt = false
	$hurtbox.monitorable = true

func _on_animated_sprite_2d_animation_finished() -> void:
	if sprite.animation == "death":
		sprite.queue_free()
		

func _on_death_timeout() -> void:
	death.emit()

func _on_light_timeout() -> void:
	attack_impulse = Vector2.ZERO
	input_enable = true
	attacking = false
	kind_attack = 0

func _on_heavy_d_timeout() -> void:
	input_enable = true
	attacking = false
	
	kind_attack = 0
