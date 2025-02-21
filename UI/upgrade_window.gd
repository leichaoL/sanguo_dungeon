extends Control

@onready var building: Label = $PanelContainer/MarginContainer/VBoxContainer/Title/HBoxContainer/Building
@onready var cur_production_label: Label = $PanelContainer/MarginContainer/VBoxContainer/Compare/MarginContainer/HBoxContainer/VBoxContainer/CurProduction/CurProductionLabel
@onready var next_level_label: Label = $PanelContainer/MarginContainer/VBoxContainer/Title/HBoxContainer/NextLevel
@onready var upgrade_production_label: Label = $PanelContainer/MarginContainer/VBoxContainer/Compare/MarginContainer/HBoxContainer/UpgradeProduction/UpgradeProductionLabel
@onready var resource_texture: TextureRect = $PanelContainer/MarginContainer/VBoxContainer/Compare/MarginContainer/HBoxContainer/VBoxContainer/CurProduction/ResourceTexture
@onready var upgrade_production: VBoxContainer = $PanelContainer/MarginContainer/VBoxContainer/Compare/MarginContainer/HBoxContainer/UpgradeProduction
@onready var cur_production: HBoxContainer = $PanelContainer/MarginContainer/VBoxContainer/Compare/MarginContainer/HBoxContainer/VBoxContainer/CurProduction
@onready var label: Label = $PanelContainer/MarginContainer/VBoxContainer/Compare/MarginContainer/HBoxContainer/VBoxContainer/Label



var building_type: ProductionBuildingModel.ProductionBuildingType

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.try_upgrade_production_building.connect(show_upgrade_needs)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func show_upgrade_needs(type: ProductionBuildingModel.ProductionBuildingType) -> void:
	
	self.building_type = type
	var building_name = production_building_manager.get_production_building(type).name	
	var current_level = production_building_manager.get_production_building_level(type)
	var upgrade_cost = production_building_manager.get_production_building_upgrade_cost(type)
	
	var next_level = current_level + 1
	var next_speed = production_building_manager.get_production_building_production_rate(type, next_level)
	var cur_speed = production_building_manager.get_production_building_production_rate(type, current_level)

	# 更新界面
	building.text = building_name
	next_level_label.text = str(next_level)
	
	if type != ProductionBuildingModel.ProductionBuildingType.BARRACKS:
		cur_production_label.text = "%s/s" %cur_speed
		upgrade_production_label.text = "%s/s → %s/s" % [cur_speed, next_speed]
	else:
		label.text = '当前建筑不产出资源'
		cur_production.visible = false
		upgrade_production.visible = false
		
		
	match type:
		ProductionBuildingModel.ProductionBuildingType.FARM:
			resource_texture.texture = preload("res://assets/Objects/food.atlastex")
		ProductionBuildingModel.ProductionBuildingType.LOGGING_CAMP:
			resource_texture.texture = preload("res://assets/Objects/wood.atlastex")
		ProductionBuildingModel.ProductionBuildingType.QUARRY:
			resource_texture.texture = preload("res://assets/Objects/stone.atlastex")
		ProductionBuildingModel.ProductionBuildingType.MINING_SITE:
			resource_texture.texture = preload("res://assets/Objects/gold.atlastex")
	
	# 更新资源需求显示
	var resource_nodes = {
		ResourceModel.ResourceType.FOOD: $PanelContainer/MarginContainer/VBoxContainer/Compare/MarginContainer/HBoxContainer/VBoxContainer/FoodNeeds/Label,
		ResourceModel.ResourceType.WOOD: $PanelContainer/MarginContainer/VBoxContainer/Compare/MarginContainer/HBoxContainer/VBoxContainer/WoodNeeds/Label,
		ResourceModel.ResourceType.STONE: $PanelContainer/MarginContainer/VBoxContainer/Compare/MarginContainer/HBoxContainer/VBoxContainer/StoneNeeds/Label,
		ResourceModel.ResourceType.GOLD: $PanelContainer/MarginContainer/VBoxContainer/Compare/MarginContainer/HBoxContainer/VBoxContainer/GoldNeeds/Label
	}

	for resource_type in resource_nodes.keys():
		
		var cost = upgrade_cost.get(resource_type, 0)
		resource_nodes[resource_type].text = str(cost)
		# 如果需求为0则隐藏对应资源行
		resource_nodes[resource_type].get_parent().visible = cost > 0



func _on_cancle_pressed() -> void:
	self.visible = false


func _on_confirm_pressed() -> void:
	EventBus.confirm_upgrade_production_building.emit(building_type)
	show_upgrade_needs(building_type)
	
	
