extends Node3D

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


# ------------------------------------------------------------------------------
# Onready Variables
# ------------------------------------------------------------------------------
@onready var _player_control: PlayerControl = $PlayerControl
@onready var _player_control_8: PlayerControl8 = $PlayerControl8


@onready var _sprite_actor: SpriteActor = $GridMap/SpriteActor
@onready var _character_actor: CharacterActor = $GridMap/CharacterActor

@onready var _8d_instructions: VBoxContainer = $"CanvasLayer/Controls/HBC/8D Instructions"
@onready var _tank_instructions: VBoxContainer = $"CanvasLayer/Controls/HBC/Tank Instructions"


# ------------------------------------------------------------------------------
# Setters / Getters
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Override Methods
# ------------------------------------------------------------------------------
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
	if event.is_action_pressed("controller_toggle"):
		if _player_control.active:
			_player_control.active = false
			_player_control_8.active = true
		else:
			_player_control_8.active = false
			_player_control.active = true
		_8d_instructions.visible = _player_control_8.active
		_tank_instructions.visible = _player_control.active
	if event.is_action_pressed("actor_toggle") and _player_control.active:
		if _player_control.actor == _sprite_actor:
			_player_control.actor = _character_actor
		else:
			_player_control.actor = _sprite_actor
	if event.is_action_pressed("Dummy"):
		print("You called the DUMMY action... Dummy!")

# ------------------------------------------------------------------------------
# Private Methods
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Public Methods
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------



