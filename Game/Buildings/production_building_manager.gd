extends Node

class_name ProductionBuildingManager 

var production_building_repository: ProductionBuildingRepository = ProductionBuildingRepository.new()

# 封装数据访问方法
func get_production_building(type: ProductionBuildingModel.ProductionBuildingType) -> ProductionBuildingModel:
	return production_building_repository.get_production_building(type)

func get_production_building_level(type: ProductionBuildingModel.ProductionBuildingType) -> int:
	return production_building_repository.get_production_building_level(type)

func get_production_building_production_rate(type: ProductionBuildingModel.ProductionBuildingType) -> int:
	return production_building_repository.get_production_building_production_rate(type)

func get_production_building_storage_capacity(type: ProductionBuildingModel.ProductionBuildingType) -> int:
	return production_building_repository.get_production_building_storage_capacity(type)

func get_production_building_upgrade_cost(type: ProductionBuildingModel.ProductionBuildingType) -> int:
	return production_building_repository.get_production_building_upgrade_cost(type)

# 生产建筑升级
func upgrade_production_building(type: ProductionBuildingModel.ProductionBuildingType) -> void:
	var pb = get_production_building(type)
	pb.level += 1
	production_building_repository.update_production_building(pb)

