@tool
extends Area2D

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
@export_category("Mobile Thumbstick")
@export var thumbstick : THUMBSTICK = THUMBSTICK.Left 
@export_subgroup("Radii")
@export var well_radius : float = 128.0:					set=set_well_radius
@export var stick_radius : float = 64:							set=set_stick_radius
@export var dead_zone_radius : float = 0.0:					set=set_dead_zone_radius
@export_subgroup("Visuals")
@export var well_sprite : Texture:							set=set_well_sprite
@export var stick_sprite : Texture:							set=set_stick_sprite


# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var _touch_index : int = -1

# ------------------------------------------------------------------------------
# Onready Variables
# ------------------------------------------------------------------------------
@onready var _well_sprite: Sprite2D = %WellSprite
@onready var _stick_sprite: Sprite2D = %StickSprite
@onready var _cshape: CollisionShape2D = %CollisionShape2D


# ------------------------------------------------------------------------------
# Setters / Getters
# ------------------------------------------------------------------------------
func set_stick_radius(r : float) -> void:
	if r > 0.0:
		stick_radius = r
		if _cshape != null:
			_cshape.shape.radius = stick_radius
		queue_redraw()

func set_well_radius(r : float) -> void:
	if r > 0.0:
		well_radius = r
		queue_redraw()

func set_dead_zone_radius(r : float) -> void:
	if r >= 0.0:
		dead_zone_radius = min(stick_radius, r)
		queue_redraw()

func set_well_sprite(t : Texture) -> void:
	well_sprite = t
	_ChangeSpriteTexture(_well_sprite, t)

func set_stick_sprite(t : Texture) -> void:
	stick_sprite = t
	_ChangeSpriteTexture(_stick_sprite, stick_sprite)

# ------------------------------------------------------------------------------
# Override Methods
# ------------------------------------------------------------------------------
func _ready() -> void:
	_ChangeSpriteTexture(_well_sprite, well_sprite)
	_ChangeSpriteTexture(_stick_sprite, stick_sprite)
	set_stick_radius(stick_radius)

func _draw() -> void:
	if not Engine.is_editor_hint(): return
	draw_arc(Vector2.ZERO, well_radius, 0.0, 2*PI, 32, Color.WHEAT, 2.0, true)
	draw_arc(Vector2.ZERO, stick_radius, 0.0, 2*PI, 32, Color.AQUA, 2.0, true)
	draw_arc(Vector2.ZERO, dead_zone_radius, 0.0, 2*PI, 32, Color.RED, 2.0, true)


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
		if _stick_sprite.position.length() > well_radius:
			_stick_sprite.position = _stick_sprite.position.normalized() * well_radius
		_SendAxisEvent()

# ------------------------------------------------------------------------------
# Private Methods
# ------------------------------------------------------------------------------
func _ChangeSpriteTexture(sprite : Sprite2D, t : Texture) -> void:
	if sprite != null:
		sprite.texture = t

func _IsOnStick(touch_position : Vector2) -> bool:
	var dist : float = global_position.distance_to(touch_position)
	return dist <= stick_radius

func _GetStrength() -> Vector2:
	var maxlen : float = well_radius - dead_zone_radius
	
	var dirlen : float = _stick_sprite.position.length() - dead_zone_radius
	var strength : float = dirlen / maxlen
	
	return Vector2.ZERO if strength < 0.01 else _stick_sprite.position.normalized() * strength

func _SendAxisEvent() -> void:
	var strength : Vector2 = _GetStrength()
	var e : InputEventJoypadMotion = InputEventJoypadMotion.new()
	e.axis = JOY_AXIS_LEFT_X if thumbstick == THUMBSTICK.Left else JOY_AXIS_RIGHT_X
	e.axis_value = strength.x
	Input.parse_input_event(e)
	e = InputEventJoypadMotion.new()
	e.axis = JOY_AXIS_LEFT_Y if thumbstick == THUMBSTICK.Left else JOY_AXIS_RIGHT_Y
	e.axis_value = strength.y
	Input.parse_input_event(e)

# ------------------------------------------------------------------------------
# Public Methods
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------


