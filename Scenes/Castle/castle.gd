extends Area2D

@export var buildings: PackedScene
var is_player_in_area: bool = false

func _process(delta: float) -> void:
	if Input.is_action_pressed("confirm") and is_player_in_area:
		self.get_tree().change_scene_to_packed(buildings)

func _on_area_entered(area: Area2D) -> void:
	if area.get_parent().name == 'Player':
		is_player_in_area = true
		$EnterTip.visible = true
		
func _on_area_exited(area: Area2D) -> void:
	if area.get_parent().name == 'Player':
		is_player_in_area = false
		$EnterTip.visible = false
