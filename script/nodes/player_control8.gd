extends Node
class_name PlayerControl8

# ------------------------------------------------------------------------------
# Signals
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Constants and ENUMs
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------
@export_category("Player Control8")
@export var active : bool = true:							set = set_active
@export var actor : Actor8 = null:							set = set_actor
@export var iso_camera : IsoCamera = null:					set = set_iso_camera

# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Onready Variables
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Setters / Getters
# ------------------------------------------------------------------------------
func set_active(a : bool) -> void:
	active = a
	_UpdateCamTarget()
	set_process_unhandled_input(active)

func set_actor(a : Actor8) -> void:
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
# Override Methods
# ------------------------------------------------------------------------------
func _ready() -> void:
	_UpdateCamTarget()
	set_process_unhandled_input(active)

func _unhandled_input(event: InputEvent) -> void:
	if actor != null:
		if _IsEventOneOf(event, ["forward", "backward", "left", "right"]):
			var movement : Vector2 = Input.get_vector("left", "right", "backward", "forward")
			actor.move(movement)
	if iso_camera != null:
		if event.is_action_pressed("turn_left"):
			iso_camera.rotate_left()
		if event.is_action_pressed("turn_right"):
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
		if event.is_action(action):
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



