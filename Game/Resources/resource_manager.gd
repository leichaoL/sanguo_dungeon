extends Node

class_name ResourceManager 

var resource_repository: ResourceRepository = ResourceRepository.new()

# 封装数据访问方法
func get_resource(type: ResourceModel.ResourceType) -> ResourceModel:
	return resource_repository.get_resource(type)

func get_resource_amount(type: ResourceModel.ResourceType) -> int:
	return resource_repository.get_resource_amount(type)

func get_all_resources() -> Array[ResourceModel]:
	return resource_repository.get_all_resources()

func update_resource(res: ResourceModel) -> void:
	resource_repository.update_resource(res)

# 新增资源
func add_resource(type: ResourceModel.ResourceType, amount: int) -> void:
	var res = get_resource(type)
	res.amount += amount
	update_resource(res)

# 消耗资源
func remove_resource(type: ResourceModel.ResourceType, amount: int) -> void:
	var res = get_resource(type)
	res.amount -= amount
	update_resource(res)
