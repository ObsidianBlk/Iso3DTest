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
@export var actor : Actor = null:		set = set_actor

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

# ------------------------------------------------------------------------------
# Setters / Getters
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Override Methods
# ------------------------------------------------------------------------------
func _unhandled_input(event: InputEvent) -> void:
	if actor == null: return

	if _IsEventOneOf(event, ["forward", "backward", "left", "right"]):
		var movement : Vector2 = Input.get_vector("left", "right", "backward", "forward")
		actor.move(movement)
	if _IsEventOneOf(event, ["turn_left", "turn_right"]):
		var strength : float = Input.get_action_strength("turn_right") - Input.get_action_strength("turn_left")
		actor.turn(strength)

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



