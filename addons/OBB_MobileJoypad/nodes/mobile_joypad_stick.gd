@tool
extends Area2D
class_name MobileJoypadStick

# ------------------------------------------------------------------------------
# Signals
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Constants and ENUMs
# ------------------------------------------------------------------------------
enum THUMBSTICK {Left=0, Right=1}

# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------
@export_category("Mobile Joypad Stick")
@export var config : MobileJoypadStickConfig = null:			set=set_config
@export var base_texture : Texture2D = null:					set=set_base_texture
@export var stick_texture : Texture2D = null:					set=set_stick_texture

# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var _touch_index : int = -1

# ------------------------------------------------------------------------------
# Onready Variables
# ------------------------------------------------------------------------------
@onready var _base_sprite: Sprite2D = Sprite2D.new()
@onready var _stick_sprite: Sprite2D = Sprite2D.new()
@onready var _cshape: CollisionShape2D = CollisionShape2D.new()


# ------------------------------------------------------------------------------
# Setters / Getters
# ------------------------------------------------------------------------------
func set_config(conf : MobileJoypadStickConfig) -> void:
	_DisconnectConfig()
	config = conf
	_ConnectConfig()
	_UpdateCollision()
	queue_redraw()

func set_base_texture(t : Texture2D) -> void:
	base_texture = t
	_UpdateSprites()

func set_stick_texture(t : Texture2D) -> void:
	stick_texture = t
	_UpdateSprites()

# ------------------------------------------------------------------------------
# Override Methods
# ------------------------------------------------------------------------------
func _ready() -> void:
	# -- Laying out the node
	_base_sprite.show_behind_parent = true
	_stick_sprite.show_behind_parent = true
	add_child(_base_sprite)
	add_child(_stick_sprite)
	_cshape.shape = CircleShape2D.new()
	add_child(_cshape)
	# --
	
	_UpdateSprites()
	
	_ConnectConfig()
	_UpdateCollision()
	queue_redraw()

func _draw() -> void:
	if not Engine.is_editor_hint() or config == null: return
	draw_arc(Vector2.ZERO, config.base_radius, 0.0, 2*PI, 32, Color.WHEAT, 2.0, true)
	draw_arc(Vector2.ZERO, config.stick_radius, 0.0, 2*PI, 32, Color.AQUA, 2.0, true)
	draw_arc(Vector2.ZERO, config.dead_zone_radius, 0.0, 2*PI, 32, Color.RED, 2.0, true)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.is_pressed() and _touch_index < 0:
			if _IsOnStick(event.position):
				_touch_index = event.index
		elif event.is_released() and _touch_index == event.index:
			_touch_index = -1
			_stick_sprite.position = Vector2.ZERO
			_SendAxisEvent()
	if event is InputEventScreenDrag and _touch_index == event.index:
		_stick_sprite.global_position = event.position
		if _stick_sprite.position.length() > config.base_radius:
			_stick_sprite.position = _stick_sprite.position.normalized() * config.base_radius
		_SendAxisEvent()

# ------------------------------------------------------------------------------
# Private Methods
# ------------------------------------------------------------------------------
func _DisconnectConfig() -> void:
	if config == null: return
	if config.base_radius_changed.is_connected(_on_radius_changed.bind(false)):
		config.base_radius_changed.disconnect(_on_radius_changed.bind(false))
	if config.stick_radius_changed.is_connected(_on_radius_changed.bind(true)):
		config.stick_radius_changed.disconnect(_on_radius_changed.bind(true))
	if config.dead_zone_radius_changed.is_connected(_on_radius_changed.bind(false)):
		config.dead_zone_radius_changed.disconnect(_on_radius_changed.bind(false))

func _ConnectConfig() -> void:
	if config == null: return
	if not config.base_radius_changed.is_connected(_on_radius_changed.bind(false)):
		config.base_radius_changed.connect(_on_radius_changed.bind(false))
	if not config.stick_radius_changed.is_connected(_on_radius_changed.bind(true)):
		config.stick_radius_changed.connect(_on_radius_changed.bind(true))
	if not config.dead_zone_radius_changed.is_connected(_on_radius_changed.bind(false)):
		config.dead_zone_radius_changed.connect(_on_radius_changed.bind(false))


func _UpdateCollision() -> void:
	if config == null or _cshape == null: return
	_cshape.shape.radius = config.stick_radius

func _UpdateSprites() -> void:
	if _base_sprite != null:
		_base_sprite.texture = base_texture
	if _stick_sprite != null:
		_stick_sprite.texture = stick_texture

func _IsOnStick(touch_position : Vector2) -> bool:
	if config == null: return false
	var dist : float = global_position.distance_to(touch_position)
	return dist <= config.stick_radius

func _GetStrength() -> Vector2:
	if config == null: return Vector2.ZERO
	var maxlen : float = config.base_radius - config.dead_zone_radius
	
	var dirlen : float = _stick_sprite.position.length() - config.dead_zone_radius
	var strength : float = dirlen / maxlen
	
	return Vector2.ZERO if strength < 0.01 else _stick_sprite.position.normalized() * strength

func _SendAxisEvent() -> void:
	if config == null: return
	
	var strength : Vector2 = _GetStrength()
	var e : InputEventJoypadMotion = InputEventJoypadMotion.new()
	e.axis = JOY_AXIS_LEFT_X if config.thumbstick == THUMBSTICK.Left else JOY_AXIS_RIGHT_X
	e.axis_value = strength.x
	Input.parse_input_event(e)
	e = InputEventJoypadMotion.new()
	e.axis = JOY_AXIS_LEFT_Y if config.thumbstick == THUMBSTICK.Left else JOY_AXIS_RIGHT_Y
	e.axis_value = strength.y
	Input.parse_input_event(e)

# ------------------------------------------------------------------------------
# Public Methods
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------
func _on_radius_changed(_radius : float, update_collision : bool) -> void:
	if update_collision:
		_UpdateCollision()
	queue_redraw()
