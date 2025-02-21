extends Node

class_name ProductionBuildingManager 

var production_building_repository: ProductionBuildingRepository = ProductionBuildingRepository.new()

func _ready() -> void:
	EventBus.confirm_upgrade_production_building.connect(upgrade_production_building)
	EventBus.production_building_upgrade_failed.connect(_on_upgrade_failed)

func _on_upgrade_failed(type: ProductionBuildingModel.ProductionBuildingType, fail_reason: String) -> void:
	print("建筑%s 升级失败：%s" % [ProductionBuildingModel.ProductionBuildingType.keys()[type], fail_reason])

# 封装数据访问方法
# 获取生产建筑
func get_production_building(type: ProductionBuildingModel.ProductionBuildingType) -> ProductionBuildingModel:
	return production_building_repository.get_production_building(type)

# 获取生产建筑等级
func get_production_building_level(type: ProductionBuildingModel.ProductionBuildingType) -> int:
	return production_building_repository.get_production_building_level(type)

# 获取生产建筑生产速度
func get_production_building_production_rate(type: ProductionBuildingModel.ProductionBuildingType, level: int = -1) -> int:
	return production_building_repository.get_production_building_production_rate(type, level)

# 获取生产建筑存储容量
func get_production_building_storage_capacity(type: ProductionBuildingModel.ProductionBuildingType, level: int = -1) -> int:
	return production_building_repository.get_production_building_storage_capacity(type, level)
	
# 获取生产建筑升级成本
func get_production_building_upgrade_cost(type: ProductionBuildingModel.ProductionBuildingType, level: int = -1) -> Dictionary:
	return production_building_repository.get_production_building_upgrade_cost(type, level)

# 获取生产建筑升级条件
func get_production_building_upgrade_conditions(type: ProductionBuildingModel.ProductionBuildingType) -> Dictionary:
	return production_building_repository.get_production_building_upgrade_conditions(type)

# 获取建筑名称
func get_building_name(type: ProductionBuildingModel.ProductionBuildingType) -> String:
	return production_building_repository.get_building_name(type)

# 生产建筑升级
func upgrade_production_building(type: ProductionBuildingModel.ProductionBuildingType) -> void:
	
	if can_upgrade_production_building(type):
		var upgrade_cost = get_production_building_upgrade_cost(type)
		for resource_type in upgrade_cost.keys():
			resource_manager.remove_resource(resource_type, upgrade_cost[resource_type])  # 扣减所需资源
			EventBus.resource_changed.emit(resource_type, upgrade_cost[resource_type], resource_manager.get_resource_capacity(resource_type))	
		var pb = get_production_building(type)
		pb.level += 1
		
		production_building_repository.update_production_building(pb)

		EventBus.production_building_upgrade_success.emit(type)


# 检查建筑是否可以升级
func can_upgrade_production_building(type: ProductionBuildingModel.ProductionBuildingType) -> bool:

	var upgrade_conditions = get_production_building_upgrade_conditions(type)
	if upgrade_conditions:
		
		for condition in upgrade_conditions:
			if get_production_building_level(condition) < upgrade_conditions[condition]:
				var fail_reason = "建筑 %s 需要 %s 级 %s 才能升级" % [production_building_repository.get_building_name(type), upgrade_conditions[condition], production_building_repository.get_building_name(condition)]
				print(fail_reason)
				EventBus.production_building_upgrade_failed.emit(type, fail_reason)
				return false

	# 检查升级所需资源是否充足
	var upgrade_cost = get_production_building_upgrade_cost(type)
	for resource_type in upgrade_cost.keys():
		if resource_manager.get_resource_amount(resource_type) < upgrade_cost[resource_type]:
			var fail_reason = "建筑 %s 升级所需的资源不足" % production_building_repository.get_building_name(type)
			print(fail_reason)
			EventBus.production_building_upgrade_failed.emit(type, fail_reason)
			return false

	return true
