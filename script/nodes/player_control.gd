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
@export var actor : Actor = null:							set = set_actor
@export var iso_camera_manager : IsoCameraManager = null:	set = set_iso_camera_manager

# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Onready Variables
# ------------------------------------------------------------------------------
func set_actor(a : Actor) -> void:
	if a != actor:
		_DisconnectActor()
		actor = a
		_ConnectActor()
		if iso_camera_manager != null:
			iso_camera_manager.actor = actor

func set_iso_camera_manager(icm : IsoCameraManager) -> void:
	if iso_camera_manager !=icm:
		iso_camera_manager = icm
		iso_camera_manager.actor = actor

# ------------------------------------------------------------------------------
# Setters / Getters
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Override Methods
# ------------------------------------------------------------------------------
func _ready() -> void:
	if iso_camera_manager != null:
		iso_camera_manager.actor = actor

func _unhandled_input(event: InputEvent) -> void:
	if actor != null:
		if _IsEventOneOf(event, ["forward", "backward", "left", "right"]):
			var movement : Vector2 = Input.get_vector("left", "right", "backward", "forward")
			actor.move(movement)
		if _IsEventOneOf(event, ["turn_left", "turn_right"]):
			var strength : float = Input.get_axis("turn_right", "turn_left")
			actor.turn(strength)
	if iso_camera_manager != null:
		if event.is_action_pressed("camera_rotate_left"):
			iso_camera_manager.rotate_camera_left()
		if event.is_action_pressed("camera_rotate_right"):
			iso_camera_manager.rotate_camera_right()

# ------------------------------------------------------------------------------
# Private Methods
# ------------------------------------------------------------------------------
func _ConnectActor() -> void:
	if actor == null: return

func _DisconnectActor() -> void:
	if actor == null: return

func _IsEventOneOf(event : InputEvent, actions : Array[String]) -> bool:
	for action in actions:
		if event.is_action(action):
			return true
	return false

# ------------------------------------------------------------------------------
# Public Methods
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------



