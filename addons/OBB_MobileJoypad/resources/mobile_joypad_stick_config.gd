@tool
extends Resource
class_name MobileJoypadStickConfig

# ------------------------------------------------------------------------------
# Signals
# ------------------------------------------------------------------------------
signal thumbstick_changed(t : THUMBSTICK)
signal stick_radius_changed(radius : float)
signal base_radius_changed(radius : float)
signal dead_zone_radius_changed(radius : float)

# ------------------------------------------------------------------------------
# Constants and ENUMs
# ------------------------------------------------------------------------------
enum THUMBSTICK {Left=0, Right=1}

# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------
@export_category("Mobile Joypad Stick Config")
@export var thumbstick : THUMBSTICK = THUMBSTICK.Left 
@export_subgroup("Radii")
@export var base_radius : float = 128.0:					set=set_base_radius
@export var stick_radius : float = 64:						set=set_stick_radius
@export var dead_zone_radius : float = 0.0:					set=set_dead_zone_radius

# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Onready Variables
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Setters / Getters
# ------------------------------------------------------------------------------
func set_thumbstick(t : THUMBSTICK) -> void:
	thumbstick = t
	thumbstick_changed.emit(thumbstick)
	changed.emit()

func set_stick_radius(r : float) -> void:
	if r > 0.0:
		stick_radius = r
		stick_radius_changed.emit(stick_radius)
		changed.emit()

func set_base_radius(r : float) -> void:
	if r > 0.0:
		base_radius = r
		base_radius_changed.emit(base_radius)
		changed.emit()

func set_dead_zone_radius(r : float) -> void:
	if r >= 0.0:
		dead_zone_radius = min(stick_radius, r)
		dead_zone_radius_changed.emit(dead_zone_radius)
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


# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------



