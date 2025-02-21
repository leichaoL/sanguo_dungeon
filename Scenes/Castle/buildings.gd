extends Control


@onready var upgrade_window: Control = $UpgradeWindow
@onready var farm_contanier: VBoxContainer = $Production/Production/FarmContanier
@onready var wood_contanier: VBoxContainer = $Production/Production/WoodContanier
@onready var stone_contanier: VBoxContainer = $Production/Production/StoneContanier
@onready var gold_contanier: VBoxContainer = $Production/Production/GoldContanier
@onready var accept_dialog: AcceptDialog = $AcceptDialog
@onready var soldier_num: RichTextLabel = $Soldier/SoldierNum


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# pass
	refresh_all_building()
	EventBus.production_building_upgrade_success.connect(refresh_building)
	EventBus.production_building_upgrade_failed.connect(fail_dialog)



func _on_back_to_main_pressed() -> void:
	self.get_tree().change_scene_to_file("res://Scenes/Maps/main_map.tscn")



func _on_farm_pressed() -> void:
	EventBus.try_upgrade_production_building.emit(ProductionBuildingModel.ProductionBuildingType.FARM)
	upgrade_window.visible = true
	
	
 
func _on_wood_pressed() -> void:
	EventBus.try_upgrade_production_building.emit(ProductionBuildingModel.ProductionBuildingType.LOGGING_CAMP)
	upgrade_window.visible = true


func _on_stone_pressed() -> void:
	EventBus.try_upgrade_production_building.emit(ProductionBuildingModel.ProductionBuildingType.QUARRY)
	upgrade_window.visible = true


func _on_gold_pressed() -> void:
	EventBus.try_upgrade_production_building.emit(ProductionBuildingModel.ProductionBuildingType.MINING_SITE)
	upgrade_window.visible = true

func _on_barracks_pressed() -> void:
	EventBus.try_upgrade_production_building.emit(ProductionBuildingModel.ProductionBuildingType.BARRACKS)
	upgrade_window.visible = true


func refresh_all_building():
	'''刷新所有建筑的ui信息'''
	
	for type in production_building_manager.production_building_repository.production_buildings.keys():
		refresh_building(type)


func refresh_building(type: ProductionBuildingModel.ProductionBuildingType):
	'''刷新指定建筑的ui信息'''
	
	if type != ProductionBuildingModel.ProductionBuildingType.BARRACKS:
		var building_container: VBoxContainer = null

		match type:
			ProductionBuildingModel.ProductionBuildingType.FARM:
				building_container = farm_contanier
			ProductionBuildingModel.ProductionBuildingType.LOGGING_CAMP:
				building_container = wood_contanier
			ProductionBuildingModel.ProductionBuildingType.QUARRY:
				building_container = stone_contanier
			ProductionBuildingModel.ProductionBuildingType.MINING_SITE:
				building_container = gold_contanier

		var building_label:HBoxContainer = building_container.get_node("HBoxContainer")
		var label: Label = building_label.get_node("Label")
		var lvl_label: Label = building_label.get_node("LvlLabel")
		var shadow: TextureButton = building_container.get_node("BuildingName/Shadow")
		
		var production_speed := production_building_manager.get_production_building_production_rate(type)
		var production_lvl := production_building_manager.get_production_building_level(type)
		building_container.tooltip_text = "当前生产速度：%d/s" %[production_speed]
		
		label.text = production_building_manager.get_building_name(type)
		lvl_label.text = "等级: %d" % production_lvl if production_lvl > 0 else "未解锁"
		shadow.visible = (production_lvl == 0) 
	else:
		
		var barracks_label: Label = get_node("MillitaryContainer/Millitary/Millitary/HBoxContainer/Label")
		var barracks_lvl: Label = get_node("MillitaryContainer/Millitary/Millitary/HBoxContainer/LvlLabel")
		var barracks_shadow: TextureButton = get_node("MillitaryContainer/Millitary/Millitary/BuildingName/Shadow")
		
		var lvl = production_building_manager.get_production_building_level(type)
		barracks_label.text = '兵营'
		barracks_lvl.text = "等级: %d" % lvl if lvl > 0 else "未解锁"
		barracks_shadow.visible = (lvl == 0)
		var res_type = resource_manager.get_resource_type_by_production_building_type(type)
		soldier_num.text = "%d/%d" %[resource_manager.get_resource_amount(res_type), production_building_manager.get_production_building_storage_capacity(type)]


func fail_dialog(type: ProductionBuildingModel.ProductionBuildingType, fail_reason: String):
	
	accept_dialog.visible = true
	var building_name: String = production_building_manager.get_building_name(type)
	accept_dialog.title = "建筑%s升级失败" %building_name
	accept_dialog.dialog_text = fail_reason


func _on_recruit_button_pressed() -> void:
	EventBus.recruit_solider.emit()
