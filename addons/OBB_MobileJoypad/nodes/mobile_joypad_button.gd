@tool
extends Area2D
class_name MobileJoypadButton

# ------------------------------------------------------------------------------
# Signals
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Constants and ENUMs
# ------------------------------------------------------------------------------
const FINGER_SHAPE_RADIUS : float = 10.0

# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------
@export_category("Mobile Joypad Button")
@export var config : MobileJoypadButtonConfig = null:			set = set_config

# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var _touch_idx : int = -1
var _finger_shape : CircleShape2D = CircleShape2D.new()

# ------------------------------------------------------------------------------
# Onready Variables
# ------------------------------------------------------------------------------
@onready var _cshape: CollisionShape2D = CollisionShape2D.new()
@onready var _sprite: Sprite2D = Sprite2D.new()
@onready var _finger_position: Marker2D = Marker2D.new()


# ------------------------------------------------------------------------------
# Setters / Getters
# ------------------------------------------------------------------------------
func set_config(conf : MobileJoypadButtonConfig) -> void:
	_DisconnectConfig()
	config = conf
	_ConnectConfig()
	_UpdateSprite()
	_on_shape_changed()

# ------------------------------------------------------------------------------
# Override Methods
# ------------------------------------------------------------------------------
func _ready() -> void:
	# --- Layout setup
	add_child(_sprite)
	add_child(_finger_position)
	add_child(_cshape)
	# ---
	
	_finger_shape.radius = FINGER_SHAPE_RADIUS
	_ConnectConfig()
	_UpdateSprite()
	_on_shape_changed()
	input_event.connect(_on_input_event)

func _unhandled_input(event: InputEvent) -> void:
	if _touch_idx < 0 or _finger_position == null: return
	if event is InputEventScreenDrag and event.index == _touch_idx:
		_finger_position.global_position = event.position
		if not _cshape.shape.collide(_cshape.transform, _finger_shape, _finger_position.transform):
			_UpdateTouching(-1)

# ------------------------------------------------------------------------------
# Private Methods
# ------------------------------------------------------------------------------
func _DisconnectConfig() -> void:
	if config == null: return
	if config.shape_changed.is_connected(_on_shape_changed):
		config.shape_changed.disconnect(_on_shape_changed)
	if config.normal_texture_changed.is_connected(_on_normal_texture_changed):
		config.normal_texture_changed.disconnect(_on_normal_texture_changed)
	if config.pressed_texture_changed.is_connected(_on_pressed_texutre_changed):
		config.pressed_texture_changed.disconnect(_on_pressed_texutre_changed)

func _ConnectConfig() -> void:
	if config == null: return
	if not config.shape_changed.is_connected(_on_shape_changed):
		config.shape_changed.connect(_on_shape_changed)
	if not config.normal_texture_changed.is_connected(_on_normal_texture_changed):
		config.normal_texture_changed.connect(_on_normal_texture_changed)
	if not config.pressed_texture_changed.is_connected(_on_pressed_texutre_changed):
		config.pressed_texture_changed.connect(_on_pressed_texutre_changed)

func _SendInput(pressed : bool) -> void:
	if config == null: return
	var e : InputEventJoypadButton = InputEventJoypadButton.new()
	e.device = 0
	e.pressed = pressed
	e.button_index = config.get_button_id()
	e.pressure = 1.0
	Input.parse_input_event(e)

func _UpdateSprite() -> void:
	if _sprite == null: return
	if config == null:
		_sprite.texture = null
	elif _touch_idx < 0 or config.pressed_texture == null:
		_sprite.texture = config.normal_texture
	elif _touch_idx >= 0 and config.pressed_texture != null:
		_sprite.texture = config.pressed_texture

func _UpdateTouching(idx : int) -> void:
	_touch_idx = idx
	_finger_position.position = Vector2.ZERO
	_UpdateSprite()
	_SendInput(idx >= 0)

# ------------------------------------------------------------------------------
# Public Methods
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------
func _on_shape_changed() -> void:
	if _cshape == null: return
	_cshape.shape = null if config == null else config.shape

func _on_normal_texture_changed() -> void:
	if _sprite == null: return
	_UpdateSprite()

func _on_pressed_texutre_changed() -> void:
	if _sprite == null: return
	_UpdateSprite()

func _on_input_event(viewport : Node, event : InputEvent, shape_idx : int) -> void:
	if config == null: return
	if event is InputEventScreenTouch:
		if event.is_pressed() and _touch_idx < 0:
			_UpdateTouching(event.index)
		elif event.is_released() and _touch_idx == event.index:
			_UpdateTouching(-1)



