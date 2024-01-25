@tool
extends Node3D
class_name IsoCamera

# ------------------------------------------------------------------------------
# Signals
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Constants and ENUMs
# ------------------------------------------------------------------------------
const ZOOM_LEVEL_MAX : float = 20.0

# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------
@export_category("Iso Camera")
@export var follow_target : Node3D = null
@export var speed_factor : float = 5.0

@export_subgroup("Camera")
@export var current : bool:								set = set_current, get = get_current
@export_range(0.0, 1.0) var zoom_level : float:			set = set_zoom_level, get = get_zoom_level
@export var height : float:								set = set_height, get = get_height

@export_subgroup("Shake")
@export var noise : Noise = null:						set = set_noise
@export var max_amplitude : float = 10.0

# ------------------------------------------------------------------------------
# Static Variables
# ------------------------------------------------------------------------------
static var _SceneTreeInstance : SceneTree = null

# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var _tween_active : bool = false
var _tween_shake_active : bool = false
var _shake_strength : float = 0.0

# ------------------------------------------------------------------------------
# Onready Variables
# ------------------------------------------------------------------------------
@onready var _orbiter: Node3D = $Orbiter
@onready var _camera: Camera3D = $Orbiter/Camera3D


# ------------------------------------------------------------------------------
# Setters / Getters
# ------------------------------------------------------------------------------
func set_zoom_level(z : float) -> void:
	if _camera != null:
		z = clampf(z, 0.0, 1.0)
		_camera.size = ZOOM_LEVEL_MAX * z

func get_zoom_level() -> float:
	if _camera != null:
		return _camera.size / ZOOM_LEVEL_MAX
	return 0.0

func set_current(c : bool) -> void:
	if _camera != null:
		_camera.current = c

func get_current() -> bool:
	if _camera != null:
		return _camera.current
	return false

func set_height(h : float) -> void:
	if _camera != null and h > 0.0:
		var hh : float = h * 0.5
		_camera.position = Vector3(hh, h, hh)

func get_height() -> float:
	if _camera != null:
		return _camera.position.y
	return 0.0

func set_noise(n : Noise) -> void:
	if n != noise:
		noise = n
		set_process(noise != null and not Engine.is_editor_hint())

# ------------------------------------------------------------------------------
# Override Methods
# ------------------------------------------------------------------------------
func _ready() -> void:
	set_process(noise != null and not Engine.is_editor_hint())

func _enter_tree() -> void:
	if Engine.is_editor_hint(): return
	if _SceneTreeInstance == null:
		_SceneTreeInstance = get_tree()

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint(): return
	if follow_target != null:
		position = lerp(position, follow_target.position, speed_factor * delta)

func _process(delta: float) -> void:
	if Engine.is_editor_hint() or noise == null: return
	if _shake_strength > 0.0:
		_camera.h_offset = noise.get_noise_1d(Time.get_ticks_msec()) * _shake_strength
		_camera.v_offset = noise.get_noise_1d(Time.get_ticks_msec() + 200) * _shake_strength

# ------------------------------------------------------------------------------
# Private Methods
# ------------------------------------------------------------------------------
func _RotateCamera(dir : int) -> void:
	if _tween_active or _camera == null: return
	dir = clampi(dir, -1, 1)
	
	var target_rotation : Vector3 = _orbiter.rotation
	target_rotation.y += (PI * 0.5) * dir
	
	_tween_active = true
	var tween : Tween = create_tween()
	tween.tween_property(_orbiter, "rotation", target_rotation, 0.5)
	await tween.finished
	
	_orbiter.rotation.y = wrapf(_orbiter.rotation.y, 0.0, 2*PI)
	_tween_active = false

# ------------------------------------------------------------------------------
# Public Static Methods
# ------------------------------------------------------------------------------
static func Get_Current_Iso_Camera(view : Viewport = null) -> IsoCamera:
	if view == null:
		if _SceneTreeInstance != null and _SceneTreeInstance.root != null:
			view = _SceneTreeInstance.root.get_viewport()
	
	if view == null: return null
	
	var current_camera : Camera3D = view.get_camera_3d()
	if current_camera == null: return null
	
	var parent : Node3D = current_camera.get_parent()
	if parent == null: return null
	
	parent = current_camera.get_parent()
	if not parent is IsoCamera: return null
	
	return parent

# ------------------------------------------------------------------------------
# Public Methods
# ------------------------------------------------------------------------------
func rotate_left() -> void:
	_RotateCamera(-1)

func rotate_right() -> void:
	_RotateCamera(1)

func shake(strength : float, duration : float) -> void:
	if _tween_shake_active and strength > 0.0 and duration > 0.0: return
	_shake_strength = strength
	
	_tween_shake_active = true
	var tween : Tween = create_tween()
	tween.tween_property(self, "_shake_strength", 0.0, duration)
	
	await tween.finished
	_tween_shake_active = false
	_shake_strength = 0.0
	_camera.h_offset = 0.0
	_camera.v_offset = 0.0

# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------



