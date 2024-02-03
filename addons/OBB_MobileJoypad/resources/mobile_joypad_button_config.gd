@tool
extends Resource
class_name MobileJoypadButtonConfig

# ------------------------------------------------------------------------------
# Signals
# ------------------------------------------------------------------------------
signal shape_changed()
signal button_changed(b : JOYBUTTON)
signal custom_index_changed(idx : int)
signal button_id_changed(id : int)
signal normal_texture_changed()
signal pressed_texture_changed()

# ------------------------------------------------------------------------------
# Constants and ENUMs
# ------------------------------------------------------------------------------
enum JOYBUTTON {
	A=JOY_BUTTON_A,
	B=JOY_BUTTON_B,
	X=JOY_BUTTON_X,
	Y=JOY_BUTTON_Y,
	SELECT=JOY_BUTTON_BACK,
	HOME=JOY_BUTTON_GUIDE,
	START=JOY_BUTTON_START,
	LEFT_STICK=JOY_BUTTON_LEFT_STICK,
	RIGHT_STICK=JOY_BUTTON_RIGHT_STICK,
	LEFT_SHOULDER=JOY_BUTTON_LEFT_SHOULDER,
	RIGHT_SHOULDER=JOY_BUTTON_RIGHT_SHOULDER,
	DPAD_UP=JOY_BUTTON_DPAD_UP,
	DPAD_DOWN=JOY_BUTTON_DPAD_DOWN,
	DPAD_LEFT=JOY_BUTTON_DPAD_LEFT,
	DPAD_RIGHT=JOY_BUTTON_DPAD_RIGHT,
	MISC=JOY_BUTTON_MISC1,
	CUSTOM=JOY_BUTTON_MAX
}

# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------
@export_category("Mobile Joypad Button Config")
@export var shape : Shape2D = null:						set=set_shape
@export var button : JOYBUTTON = JOYBUTTON.START:		set=set_button
@export_range(16, 128) var custom_index : int = 16:		set=set_custom_index

@export_subgroup("Visuals")
@export var normal_texture : Texture = null:			set=set_normal_texture
@export var pressed_texture : Texture = null:			set=set_pressed_texture

# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Onready Variables
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Setters / Getters
# ------------------------------------------------------------------------------
func set_shape(s : Shape2D) -> void:
	shape = s
	shape_changed.emit()
	changed.emit()

func set_button(b : JOYBUTTON) -> void:
	button = b
	button_changed.emit(button)
	if button == JOYBUTTON.CUSTOM:
		button_id_changed.emit(custom_index)
	else:
		button_id_changed.emit(button)
	changed.emit()

func set_custom_index(idx : int) -> void:
	custom_index = idx
	custom_index_changed.emit(idx)
	if button == JOYBUTTON.CUSTOM:
		button_id_changed.emit(custom_index)
	changed.emit()

func set_normal_texture(t : Texture) -> void:
	normal_texture = t
	normal_texture_changed.emit()
	changed.emit()

func set_pressed_texture(t : Texture) -> void:
	pressed_texture = t
	pressed_texture_changed.emit()
	changed.emit()

# ------------------------------------------------------------------------------
# Override Methods
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Private Methods
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Public Methods
# ------------------------------------------------------------------------------
func get_button_id() -> int:
	if button != JOYBUTTON.CUSTOM:
		return button
	return custom_index

# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------



