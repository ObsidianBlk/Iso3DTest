extends Node3D
class_name IsoCameraManager

# ------------------------------------------------------------------------------
# Signals
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Constants and ENUMs
# ------------------------------------------------------------------------------
const CAMERA_ROTATIONS : Array[float] = [
	54.7,
	144.7,
	234.7,
	324.7
]

# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------
@export_category("Iso Camera Manager")
@export var actor : Actor = null

# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var _camera : Camera3D = null

var _camera_rot_index : int = 0
var _tween_active : bool = false

# ------------------------------------------------------------------------------
# Onready Variables
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Setters / Getters
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Override Methods
# ------------------------------------------------------------------------------
func _process(_delta: float) -> void:
	if actor != null:
		position = actor.position

# ------------------------------------------------------------------------------
# Private Methods
# ------------------------------------------------------------------------------
func _GetCamera() -> Camera3D:
	if _camera == null:
		for child : Node in get_children():
			if child is Camera3D:
				_camera = child
	return _camera

func _RotateCamera(dir : int) -> void:
	var camera : Camera3D = _GetCamera()
	if _tween_active or camera == null: return
	
	dir = clampi(dir, -1, 1)
	_camera_rot_index = wrapi(_camera_rot_index + dir, 0, CAMERA_ROTATIONS.size() - 1)
	
	var target_rotation : Vector3 = camera.rotation
	target_rotation.y = CAMERA_ROTATIONS[_camera_rot_index]
	
	_tween_active = true
	var tween : Tween = create_tween()
	tween.tween_property(_camera, "rotation", target_rotation, 0.5)
	await tween.finished
	
	camera.rotation.y = CAMERA_ROTATIONS[_camera_rot_index]
	_tween_active = false
	

# ------------------------------------------------------------------------------
# Public Methods
# ------------------------------------------------------------------------------
func rotate_camera_left() -> void:
	_RotateCamera(-1)

func rotate_camera_right() -> void:
	_RotateCamera(1)

# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------



