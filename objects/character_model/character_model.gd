#@tool
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
@export_category("Character Mesh")
@export var body_scene : PackedScene = null:		set = set_body_scene
@export_subgroup("Clothing")
@export var clothing : Array[PackedScene] = []:		set = set_clothing

# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var _body : MeshInstance3D = null
var _meshes : Dictionary = {}

# ------------------------------------------------------------------------------
# Onready Variables
# ------------------------------------------------------------------------------
@onready var _armature: Skeleton3D = $Armature/Armature/GeneralSkeleton

# ------------------------------------------------------------------------------
# Setters / Getters
# ------------------------------------------------------------------------------
func set_body_scene(s : PackedScene) -> void:
	if body_scene == s: return
	body_scene = s
	_UpdateBodyMesh()

func set_clothing(c : Array[PackedScene]) -> void:
	clothing = c
	_UpdateClothingMeshes()

# ------------------------------------------------------------------------------
# Override Methods
# ------------------------------------------------------------------------------
func _ready() -> void:
	_UpdateBodyMesh()
	_UpdateClothingMeshes()

# ------------------------------------------------------------------------------
# Private Methods
# ------------------------------------------------------------------------------
func _GetMeshInstance(scene : Node3D) -> MeshInstance3D:
	if scene == null: return null
	for child in scene.get_children():
		if child is MeshInstance3D:
			scene.remove_child(child)
			return child
		var result : MeshInstance3D = _GetMeshInstance(child)
		if result != null:
			return result
	return null

func _AddMeshScene(scene : PackedScene) -> void:
	if _armature == null: return
	var inst : Node3D = scene.instantiate()
	if inst == null: return
	
	var mesh : MeshInstance3D = _GetMeshInstance(inst)
	if mesh != null:
		_meshes[scene.resource_path] = mesh
		_armature.add_child(mesh)
		mesh.skeleton = mesh.get_path_to(_armature)
	inst.queue_free()

func _UpdateBodyMesh() -> void:
	if _armature == null: return
	if _body != null:
		_armature.remove_child(_body)
		_body.queue_free()
		_body = null
	
	if body_scene != null:
		var scn : Node3D = body_scene.instantiate()
		_body = _GetMeshInstance(scn)
		if _body != null:
			_armature.add_child(_body)
			_body.skeleton = _body.get_path_to(_armature)
			print(_body.position)

func _UpdateClothingMeshes() -> void:
	if _armature == null: return
	for path : String in _meshes.keys():
		if clothing.filter(func (item : PackedScene): return item.resource_name == path).size() <= 0:
			remove_mesh(path)
	
	for scene : PackedScene in clothing:
		if not scene.resource_path in _meshes:
			_AddMeshScene(scene)

# ------------------------------------------------------------------------------
# Public Methods
# ------------------------------------------------------------------------------
func add_mesh(mesh_path : String) -> void:
	if mesh_path in _meshes: return
	var mesh_scene : PackedScene = load(mesh_path)
	if mesh_scene == null: return
	_AddMeshScene(mesh_scene)

func remove_mesh(mesh_path : String) -> void:
	if not mesh_path in _meshes: return
	var mesh : MeshInstance3D = _meshes[mesh_path]
	_meshes.erase(mesh_path)
	
	_armature.remove_child(mesh)
	mesh.queue_free()

# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------



