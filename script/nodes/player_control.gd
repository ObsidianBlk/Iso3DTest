extends Node
class_name PlayerControl

# ------------------------------------------------------------------------------
# Signals
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Constants and ENUMs
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------
@export_category("Player Control")
@export var active : bool = true:							set = set_active
@export var actor : Actor = null:							set = set_actor
@export var iso_camera : IsoCamera = null:					set = set_iso_camera

# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Onready Variables
# ------------------------------------------------------------------------------
func set_active(a : bool) -> void:
	active = a
	_UpdateCamTarget()
	set_process_unhandled_input(active)


func set_actor(a : Actor) -> void:
	if a != actor:
		_DisconnectActor()
		actor = a
		_ConnectActor()
		_UpdateCamTarget()

func set_iso_camera(cam : IsoCamera) -> void:
	if iso_camera != cam:
		iso_camera = cam
		_UpdateCamTarget()

# ------------------------------------------------------------------------------
# Setters / Getters
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Override Methods
# ------------------------------------------------------------------------------
func _ready() -> void:
	_UpdateCamTarget()
	set_process_unhandled_input(active)

func _unhandled_input(event: InputEvent) -> void:
	if actor != null:
		if _IsEventOneOf(event, ["forward", "backward", "strafe_left", "strafe_right"]):
			var movement : Vector2 = Input.get_vector("strafe_left", "strafe_right", "backward", "forward")
			actor.move(movement)
		if _IsEventOneOf(event, ["left", "right"]):
			var strength : float = Input.get_axis("right", "left")
			actor.turn(strength)
	if iso_camera != null:
		if event.is_action_pressed("camera_rotate_left"):
			iso_camera.rotate_left()
		if event.is_action_pressed("camera_rotate_right"):
			iso_camera.rotate_right()

# ------------------------------------------------------------------------------
# Private Methods
# ------------------------------------------------------------------------------
func _ConnectActor() -> void:
	if actor == null: return

func _DisconnectActor() -> void:
	if actor == null: return

func _IsEventOneOf(event : InputEvent, actions : Array[String]) -> bool:
	for action in actions:
		if event.is_action(action, true):
			return true
	return false

func _UpdateCamTarget() -> void:
	if iso_camera == null: return
	iso_camera.follow_target = actor if active else null

# ------------------------------------------------------------------------------
# Public Methods
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------



