extends CharacterBody3D
class_name Actor

# ------------------------------------------------------------------------------
# Signals
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Constants and ENUMs
# ------------------------------------------------------------------------------
const ROTATION_STRENGTH_THRESHOLD : float = 0.001

# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------
@export_category("Actor")
@export var gravity : float = 9.8
@export var max_speed : float = 4.0
@export var turn_rate : float = 270.0

# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var _movement : Vector2 = Vector2.ZERO
var _rotation_strength : float = 0.0
var _rotation : float = 0.0

# ------------------------------------------------------------------------------
# Onready Variables
# ------------------------------------------------------------------------------
# TODO: Remove me and all code associated with me. I'm here temporarily
@onready var directional_sprite_3d: DirectionalSprite3D = $DirectionalSprite3D


# ------------------------------------------------------------------------------
# Setters / Getters
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Override Methods
# ------------------------------------------------------------------------------
func _physics_process(delta: float) -> void:
	_ProcessRotation(delta)
	_ProcessVelocity()
	move_and_slide()

# ------------------------------------------------------------------------------
# Private Methods
# ------------------------------------------------------------------------------
func _ProcessRotation(delta : float) -> void:
	if abs(_rotation_strength) < ROTATION_STRENGTH_THRESHOLD: return
	_rotation = wrapf(_rotation + (deg_to_rad(turn_rate) * _rotation_strength * delta), -PI, PI)
	directional_sprite_3d.relative_rotation = _rotation

func _ProcessVelocity() -> void:
	var movement_rotated : Vector2 = _movement.rotated(_rotation)
	velocity = Vector3(movement_rotated.x, 0.0, movement_rotated.y) * max_speed
	velocity += Vector3.DOWN * gravity

# ------------------------------------------------------------------------------
# Public Methods
# ------------------------------------------------------------------------------
func move(movement : Vector2) -> void:
	_movement = movement.normalized()

func turn(strength : float) -> void:
	_rotation_strength = wrapf(strength, -1.0, 1.0)

# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------



