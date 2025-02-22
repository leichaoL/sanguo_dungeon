extends Node

class_name ProductionBuildingRepository

var production_buildings: Dictionary = {}

func _init() -> void:

	production_buildings = {
		ProductionBuildingModel.ProductionBuildingType.FARM: ProductionBuildingModel.new(ProductionBuildingModel.ProductionBuildingType.FARM),
		ProductionBuildingModel.ProductionBuildingType.LOGGING_CAMP: ProductionBuildingModel.new(ProductionBuildingModel.ProductionBuildingType.LOGGING_CAMP),
		ProductionBuildingModel.ProductionBuildingType.QUARRY: ProductionBuildingModel.new(ProductionBuildingModel.ProductionBuildingType.QUARRY),
		ProductionBuildingModel.ProductionBuildingType.MINING_SITE: ProductionBuildingModel.new(ProductionBuildingModel.ProductionBuildingType.MINING_SITE),
		ProductionBuildingModel.ProductionBuildingType.BARRACKS: ProductionBuildingModel.new(ProductionBuildingModel.ProductionBuildingType.BARRACKS)
	}
	

	# 初始化生产建筑等级
	production_buildings[ProductionBuildingModel.ProductionBuildingType.FARM].level = 1
	production_buildings[ProductionBuildingModel.ProductionBuildingType.LOGGING_CAMP].level = 1
	production_buildings[ProductionBuildingModel.ProductionBuildingType.QUARRY].level = 1
	production_buildings[ProductionBuildingModel.ProductionBuildingType.MINING_SITE].level = 0
	production_buildings[ProductionBuildingModel.ProductionBuildingType.BARRACKS].level = 0
	
	# 初始化生产建筑生产速度
	production_buildings[ProductionBuildingModel.ProductionBuildingType.FARM].base_production_rate = 10
	production_buildings[ProductionBuildingModel.ProductionBuildingType.LOGGING_CAMP].base_production_rate = 8
	production_buildings[ProductionBuildingModel.ProductionBuildingType.QUARRY].base_production_rate = 5
	production_buildings[ProductionBuildingModel.ProductionBuildingType.MINING_SITE].base_production_rate = 7
	production_buildings[ProductionBuildingModel.ProductionBuildingType.BARRACKS].base_production_rate = 0
	
	# 初始化生产建筑升级成本
	production_buildings[ProductionBuildingModel.ProductionBuildingType.FARM].base_upgrade_cost = {ResourceModel.ResourceType.FOOD: 30, ResourceModel.ResourceType.WOOD: 20, ResourceModel.ResourceType.STONE: 10}
	production_buildings[ProductionBuildingModel.ProductionBuildingType.LOGGING_CAMP].base_upgrade_cost = {ResourceModel.ResourceType.WOOD: 30, ResourceModel.ResourceType.STONE: 15}
	production_buildings[ProductionBuildingModel.ProductionBuildingType.QUARRY].base_upgrade_cost = {ResourceModel.ResourceType.WOOD: 40, ResourceModel.ResourceType.STONE: 20}
	production_buildings[ProductionBuildingModel.ProductionBuildingType.MINING_SITE].base_upgrade_cost = {ResourceModel.ResourceType.WOOD: 50, ResourceModel.ResourceType.STONE: 30}
	production_buildings[ProductionBuildingModel.ProductionBuildingType.BARRACKS].base_upgrade_cost = {ResourceModel.ResourceType.WOOD: 50, ResourceModel.ResourceType.GOLD: 30}
	
	# 初始化生产建筑升级条件
	production_buildings[ProductionBuildingModel.ProductionBuildingType.MINING_SITE].upgrade_conditions = {ProductionBuildingModel.ProductionBuildingType.QUARRY: 2}
	production_buildings[ProductionBuildingModel.ProductionBuildingType.BARRACKS].upgrade_conditions = {ProductionBuildingModel.ProductionBuildingType.MINING_SITE: 2}

# 获取建筑
func get_production_building(type: ProductionBuildingModel.ProductionBuildingType) -> ProductionBuildingModel:
	return production_buildings.get(type)
	
# 获取建筑等级
func get_production_building_level(type: ProductionBuildingModel.ProductionBuildingType) -> int:
	return production_buildings.get(type).level

# 计算建筑生产速度：基础生产速度 * 建筑等级
func get_production_building_production_rate(type: ProductionBuildingModel.ProductionBuildingType, level: int = -1) -> int:
	'''
	获取建筑生产速度
	level: 建筑等级，默认为-1，表示使用建筑当前等级
	'''
	if level == -1:
		level = production_buildings.get(type).level
	return production_buildings.get(type).base_production_rate * level

# 计算建筑存储容量：基础存储容量 * 建筑等级
func get_production_building_storage_capacity(type: ProductionBuildingModel.ProductionBuildingType, level: int = -1) -> int:
	'''
	获取建筑存储容量
	level: 建筑等级，默认为-1，表示使用建筑当前等级
	'''
	if level == -1:
		level = production_buildings.get(type).level
	return production_buildings.get(type).base_storage_capacity * level

# 计算建筑升级成本：基础升级成本 * 建筑等级
func get_production_building_upgrade_cost(type: ProductionBuildingModel.ProductionBuildingType, level: int = -1) -> Dictionary:
	'''
	获取建筑升级成本
	level: 建筑等级，默认为-1，表示使用建筑当前等级
	'''
	if level == -1:
		level = production_buildings.get(type).level
	var upgrade_cost: Dictionary = {}
	for cost in production_buildings.get(type).base_upgrade_cost.keys():
		upgrade_cost[cost] = production_buildings.get(type).base_upgrade_cost[cost] * (level + 1)
	return upgrade_cost

# 获取建筑升级条件
func get_production_building_upgrade_conditions(type: ProductionBuildingModel.ProductionBuildingType) -> Dictionary:
	'''
	获取建筑升级条件
	'''
	return production_buildings.get(type).upgrade_conditions

# 更新生产建筑
func update_production_building(pb: ProductionBuildingModel) -> void:
	production_buildings[pb.type] = pb


# 获取建筑名称
func get_building_name(type: ProductionBuildingModel.ProductionBuildingType) -> String:
	return production_buildings[type].name
