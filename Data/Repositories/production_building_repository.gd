extends Node

class_name ProductionBuildingRepository

var production_buildings: Dictionary = {}

func _init() -> void:

	production_buildings = {
		ProductionBuildingModel.ProductionBuildingType.FARM: ProductionBuildingModel.new(),
		ProductionBuildingModel.ProductionBuildingType.LOGGING_CAMP: ProductionBuildingModel.new(),
		ProductionBuildingModel.ProductionBuildingType.QUARRY: ProductionBuildingModel.new(),
		ProductionBuildingModel.ProductionBuildingType.MINING_SITE: ProductionBuildingModel.new()
    }
    

    # 初始化生产建筑等级
	production_buildings[ProductionBuildingModel.ProductionBuildingType.FARM].level = 1
	production_buildings[ProductionBuildingModel.ProductionBuildingType.LOGGING_CAMP].level = 1
	production_buildings[ProductionBuildingModel.ProductionBuildingType.QUARRY].level = 1
	production_buildings[ProductionBuildingModel.ProductionBuildingType.MINING_SITE].level = 0
    

# 新增数据访问方法
func get_production_building_level(type: ProductionBuildingModel.ProductionBuildingType) -> int:
	return production_buildings.get(type).level

func get_prodction_building_production_rate(type: ProductionBuildingModel.ProductionBuildingType) -> int:
	return production_buildings.get(type).production_rate

func get_production_building_storage_capacity	(type: ProductionBuildingModel.ProductionBuildingType) -> int:
	return production_buildings.get(type).storage_capacity

func get_production_building_upgrade_cost(type: ProductionBuildingModel.ProductionBuildingType) -> int:
	return production_buildings.get(type).upgrade_cost

func update_production_building(pb: ProductionBuildingModel) -> void:
	production_buildings[pb.type] = pb

