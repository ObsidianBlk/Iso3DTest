extends AnimatedSprite3D
class_name DirectionalSprite3D

# ------------------------------------------------------------------------------
# Signals
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Constants and ENUMs
# ------------------------------------------------------------------------------
const FACING_COUNT : int = 8

# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------
@export_category("Directional Sprite 3D")
@export var base_animation : String = ""

# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var _camera : WeakRef = weakref(null)

# ------------------------------------------------------------------------------
# Onready Variables
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Setters / Getters
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Override Methods
# ------------------------------------------------------------------------------
func _process(delta: float) -> void:
	var camera : Camera3D = _GetCamera()
	if camera == null: return
	var cam_pos_2D : Vector2 = Vector2(camera.global_position.x, camera.global_position.z)
	var self_pos_2D : Vector2 = Vector2(global_position.x, global_position.z)
	
	var angle : float = self_pos_2D.angle_to_point(cam_pos_2D)
	#print(rad_to_deg(angle + global_rotation.y))
	var idx : int = _AngleToIndex(angle)
	#print("Index: ", idx)
	if idx >= 0:
		_Play(idx)

# ------------------------------------------------------------------------------
# Private Methods
# ------------------------------------------------------------------------------
func _GetCamera() -> Camera3D:
	var camera : Camera3D = _camera.get_ref()
	if camera == null:
		var viewport : Viewport = get_viewport()
		if viewport == null: return null
		camera = viewport.get_camera_3d()
		_camera = weakref(camera)
	return camera

func _AngleToIndex(angle : float) -> int:
	angle = rad_to_deg(wrapf(angle + global_rotation.y, 0, 2*PI))
	for i in range(FACING_COUNT):
		match i:
			0:
				if angle >= 337.5 or angle < 22.5:
					return i
			_:
				var target : float = i * 45.0
				if angle >= target - 22.5 and angle < target + 22.5:
					return i
	return -1

func _Play(facing : int) -> void:
	if base_animation.is_empty():
		stop()
		return
	
	var target_anim : StringName = "%s_%d"%[base_animation, facing]
	if animation == target_anim: return # Already playing animation
	var cur_frame : int = frame if animation.begins_with(base_animation) else 0
		
	play(target_anim)
	if cur_frame != 0:
		frame = cur_frame

# ------------------------------------------------------------------------------
# Public Methods
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------



