extends Node

enum InputType { KEYBOARD, XBOX, PLAYSTATION, OTHER }

signal keyboard
signal xbox
signal playstation
signal other
signal device_changed(new_type: int)

var current_input: InputType = InputType.KEYBOARD
var last_device_id: int = -2  

func _ready() -> void:
	_check_connected_controllers()
	Input.joy_connection_changed.connect(_on_joy_connection_changed)
	#print("InputManager pronto. Dispositivo iniziale:", _get_input_type_name(current_input))


func _input(event: InputEvent) -> void:
	if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		var device_id = event.device
		_update_controller_type(device_id)
	elif event is InputEventKey:
		if current_input != InputType.KEYBOARD:
			current_input = InputType.KEYBOARD
			last_device_id = -2
			_emit_for_type(current_input)
			print("Input cambiato → Tastiera")

func _update_controller_type(device_id: int) -> void:
	var name_decive := Input.get_joy_name(device_id).to_lower()
	var new_input: InputType = InputType.OTHER
	if "xbox" in name_decive or "xinput" in name_decive or "x-box" in name_decive:
		new_input = InputType.XBOX
	elif "dualsense" in name_decive or "dual" in name_decive or "playstation" in name_decive or "ps5" in name_decive or "ps4" in name_decive or "sony" in name_decive or "wireless controller" in name_decive:
		new_input = InputType.PLAYSTATION
	else:
		new_input = InputType.OTHER
	if new_input != current_input:
		current_input = new_input
		_emit_for_type(current_input)
		#print("Input cambiato →", _get_input_type_name(current_input))
	last_device_id = device_id

func _emit_for_type(t: InputType) -> void:
	match t:
		InputType.KEYBOARD:
			keyboard.emit()
		InputType.XBOX:
			xbox.emit()
		InputType.PLAYSTATION:
			playstation.emit()
		InputType.OTHER:
			other.emit()
	device_changed.emit(t)

func _on_joy_connection_changed(connected: bool) -> void:
	if connected:
		pass#print("Controller collegato:", Input.get_joy_name(device_id)) inserire "device_id: int" negli argomenti
	else:
		#print("Controller disconnesso:", device_id)
		if Input.get_connected_joypads().is_empty():
			if current_input != InputType.KEYBOARD:
				current_input = InputType.KEYBOARD
				_emit_for_type(current_input)

func _check_connected_controllers() -> void:
	var joypads = Input.get_connected_joypads()
	if joypads.size() > 0:
		pass
	else:
		current_input = InputType.KEYBOARD

func _get_input_type_name(t: InputType) -> String:
	match t:
		InputType.KEYBOARD:
			return "Tastiera"
		InputType.XBOX:
			return "Controller Xbox"
		InputType.PLAYSTATION:
			return "Controller PlayStation"
		_:
			return "Controller generico"
