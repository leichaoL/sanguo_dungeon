extends Control


@onready var upgrade_window: Control = $UpgradeWindow


# 添加建筑名称字典
var building_names = {
	"farm": "农场",
	"wood": "伐木场",
	"stone": "采石场",
	"gold": "金矿"
}
var building_production = {
	"farm": "粮草",
	"wood": "木材",
	"stone": "石材",
	"gold": "金币"	
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	refresh_building()
	GameManager.building_upgraded.connect(refresh_building)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	pass
	

func _on_back_to_main_pressed() -> void:
	self.get_tree().change_scene_to_file("res://Scenes/Maps/main_map.tscn")



func _on_farm_pressed() -> void:
	upgrade_window.refresh_needs("farm")
	upgrade_window.visible = true
	
	
 
func _on_wood_pressed() -> void:
	upgrade_window.refresh_needs("wood")
	upgrade_window.visible = true


func _on_stone_pressed() -> void:
	upgrade_window.refresh_needs("stone")
	upgrade_window.visible = true


func _on_gold_pressed() -> void:
	upgrade_window.refresh_needs("gold")
	upgrade_window.visible = true


func refresh_building():
	'''刷新建筑标签'''
	
	for building_type in building_names:
		var building:VBoxContainer = get_node("Production/Production/%sContanier" % building_type.capitalize())
		var label: Label = get_node("Production/Production/%sContanier/HBoxContainer/Label" % building_type.capitalize())
		var lvl_label: Label = get_node("Production/Production/%sContanier/HBoxContainer/LvlLabel" % building_type.capitalize())
		var shadow: TextureButton = get_node("Production/Production/%sContanier/BuildingName/Shadow" % building_type.capitalize())
		
		var production_speed := GameManager.get_build_production_speed(building_type)
		var lvl := GameManager.get_building_level(building_type)
		
		building.tooltip_text = "生产%s，当前生产速度：%d/s" %[building_production[building_type], production_speed]
		
		label.text = building_names[building_type]
		lvl_label.text = "等级: %d" % lvl if lvl > 0 else "未解锁"
		shadow.visible = (lvl == 0) 
	
	var barracks_label: Label = get_node("MillitaryContainer/Millitary/Millitary/HBoxContainer/Label")
	var barracks_lvl: Label = get_node("MillitaryContainer/Millitary/Millitary/HBoxContainer/LvlLabel")
	var barracks_shadow: TextureButton = get_node("MillitaryContainer/Millitary/Millitary/BuildingName/Shadow")
	
	var lvl = 0
	barracks_label.text = '兵营'
	barracks_lvl.text = "等级: %d" % lvl if lvl > 0 else "未解锁"
	barracks_shadow.visible = (lvl == 0)
