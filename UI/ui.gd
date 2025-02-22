extends Control

@export var buildings: PackedScene




	
func _on_buildings_pressed() -> void:
	self.get_tree().change_scene_to_packed(buildings)
