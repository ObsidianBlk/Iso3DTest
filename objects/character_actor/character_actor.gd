extends Actor
class_name CharacterActor

# ------------------------------------------------------------------------------
# Signals
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Constants and ENUMs
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var _movement : Vector2 = Vector2.ZERO
var _rotation_strength : float = 0.0

# ------------------------------------------------------------------------------
# Onready Variables
# ------------------------------------------------------------------------------
@onready var _character: Node3D = $Character
@onready var _anim: AnimationPlayer = $Character/AnimationPlayer



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
		_anim.play("Running")
	else:
		_anim.play("Idle")
	move_and_slide()

# ------------------------------------------------------------------------------
# Private Methods
# ------------------------------------------------------------------------------
func _ProcessRotation(delta : float) -> void:
	if abs(_rotation_strength) < ROTATION_STRENGTH_THRESHOLD: return
	var rot : float = _character.rotation.y
	_character.rotation.y = wrapf(rot + (deg_to_rad(turn_rate) * _rotation_strength * delta), -PI, PI)

func _ProcessVelocity() -> void:
	var movement_rotated : Vector3 = Vector3(_movement.x, 0.0, _movement.y).rotated(Vector3.UP, _character.rotation.y)
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



