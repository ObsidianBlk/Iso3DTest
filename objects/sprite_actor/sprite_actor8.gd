extends Actor8
class_name SpriteActor8

# ------------------------------------------------------------------------------
# Signals
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Constants and ENUMs
# ------------------------------------------------------------------------------
const DEG_90_RAD : float = 1.5708
const DEG_45_RAD : float = 0.7854

# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var _movement : Vector2 = Vector2.ZERO

# ------------------------------------------------------------------------------
# Onready Variables
# ------------------------------------------------------------------------------
@onready var _sprite: DirectionalSprite3D = $DirAnimSprite3D


# ------------------------------------------------------------------------------
# Setters / Getters
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Override Methods
# ------------------------------------------------------------------------------
func _physics_process(delta: float) -> void:
	var cam : IsoCamera = _GetIsoCamera()
	if cam == null: return
	
	_ProcessRotation(cam.get_current_rotation())
	_ProcessVelocity(cam.get_current_rotation())
	if _IsMoving():
		_sprite.base_animation = "run"
	else:
		_sprite.base_animation = "idle"
	move_and_slide()
	

# ------------------------------------------------------------------------------
# Private Methods
# ------------------------------------------------------------------------------
func _GetIsoCamera() -> IsoCamera:
	var viewport : Viewport = get_viewport()
	if viewport != null:
		return IsoCamera.Get_Current_Iso_Camera(viewport)
	return null

func _ProcessRotation(cam_rotation : float) -> void:
	if _movement.length() <= 0.01: return
	var mrotated : Vector2 = _movement.rotated(cam_rotation - (PI + DEG_45_RAD))
	_sprite.rotation.y = wrapf(mrotated.angle(), 0.0, PI*2)

func _ProcessVelocity(cam_rotation : float) -> void:
	print(rad_to_deg(cam_rotation + (DEG_45_RAD)))
	var movement_rotated : Vector3 = Vector3(_movement.x, 0.0, -_movement.y).rotated(Vector3.UP, cam_rotation + (DEG_45_RAD))
	velocity = movement_rotated * max_speed
	velocity += Vector3.DOWN * gravity

func _IsMoving() -> bool:
	return Vector2(velocity.x, velocity.z).length() > 0.01

# ------------------------------------------------------------------------------
# Public Methods
# ------------------------------------------------------------------------------
func move(movement : Vector2) -> void:
	_movement = movement

# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------



