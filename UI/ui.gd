extends Control

@export var buildings: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	pass

	
func _on_buildings_pressed() -> void:
	self.get_tree().change_scene_to_packed(buildings)
