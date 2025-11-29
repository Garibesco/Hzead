extends Area2D
class_name Bullet
var speedlow = 300
var speedhigh = 500
var direction = 1
var type = "high"
var in_water = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if type == "high":
		$Sprite2D.play("high")
	elif type == "low":
		$Sprite2D.play("low")
	if direction == -1:
		$Sprite2D.flip_h = true
	if in_water:
		if type == "low":
			$TimerHigh.start()
			print("timer lungo attivato, bullet: ", type)
		if type == "high":
			$TimerLow.start()
			print("timer corto attivato, bullet: ", type)
	else:
		if type == "high":
			$TimerHigh.start()
			print("timer lungo attivato, bullet: ", type)
		if type == "low":
			$TimerLow.start()
			print("timer corto attivato, bullet: ", type)
	
	#print(name, " ", type)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if in_water:
		if type == "low":
			position.x += (speedhigh-100) * direction * delta
		if type == "high":
			position.x += (speedlow+50) * direction * delta
	else:
		if type == "high":
			position.x += speedhigh * direction * delta
		if type == "low":
			position.x += speedlow * direction * delta
	

func set_specs(dir, kind):
	direction = dir
	type = kind

func set_water(water):
	in_water = water

func get_type():
	return type

func _set_position(x, y):
	position.x = x
	position.y = y

func _on_timer_timeout() -> void:
	queue_free()


func _on_timer_low_timeout() -> void:
	queue_free()
