@tool
extends ColorRect

@export var platform_size: Vector2 = Vector2(128, 16)

@onready var collider: CollisionShape2D = $StaticBody2D/CollisionShape2D

var _last_size: Vector2 = Vector2.ZERO

func _ready() -> void:
	_last_size = custom_minimum_size
	platform_size = _last_size
	_update_collider()

func _process(_delta: float) -> void:
	if not Engine.is_editor_hint():
		return

	var current_size = custom_minimum_size
	if current_size != _last_size:
		_last_size = current_size
		platform_size = current_size
		_update_collider()

func _update_collider() -> void:
	if not collider:
		return

	if not collider.shape or not (collider.shape is RectangleShape2D):
		collider.shape = RectangleShape2D.new()
		collider.shape.resource_local_to_scene = true

	collider.shape.size = _last_size
	collider.position = _last_size / 2.0

	if Engine.is_editor_hint():
		collider.property_list_changed_notify()
