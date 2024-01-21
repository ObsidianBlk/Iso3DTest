extends Actor
class_name SpriteActor

# ------------------------------------------------------------------------------
# Signals
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Constants and ENUMs
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------
@export_category("Sprite Actor")
@export var sprite_frames : SpriteFrames = null

# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var _movement : Vector2 = Vector2.ZERO
var _rotation_strength : float = 0.0

# ------------------------------------------------------------------------------
# Onready Variables
# ------------------------------------------------------------------------------
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
	if _IsMoving():
		directional_sprite_3d.base_animation = "run"
	else:
		directional_sprite_3d.base_animation = "idle"
	move_and_slide()

# ------------------------------------------------------------------------------
# Private Methods
# ------------------------------------------------------------------------------
func _ProcessRotation(delta : float) -> void:
	if abs(_rotation_strength) < ROTATION_STRENGTH_THRESHOLD: return
	var rot : float = directional_sprite_3d.global_rotation.y
	directional_sprite_3d.global_rotation.y = wrapf(rot + (deg_to_rad(turn_rate) * _rotation_strength * delta), -PI, PI)

func _ProcessVelocity() -> void:
	var movement_rotated : Vector3 = Vector3(_movement.x, 0.0, _movement.y).rotated(Vector3.UP, directional_sprite_3d.global_rotation.y)
	velocity = movement_rotated * max_speed
	velocity += Vector3.DOWN * gravity

func _IsMoving() -> bool:
	return Vector2(velocity.x, velocity.z).length() > 0.01

# ------------------------------------------------------------------------------
# Public Methods
# ------------------------------------------------------------------------------
func move(movement : Vector2) -> void:
	_movement = movement

func turn(strength : float) -> void:
	_rotation_strength = clampf(strength, -1.0, 1.0)

# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------



