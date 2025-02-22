extends Node

class_name ResourceRepository

var resources: Dictionary = {}

func _init() -> void:

	# 初始化资源
	resources = {
		ResourceModel.ResourceType.FOOD: ResourceModel.new(ResourceModel.ResourceType.FOOD, 100),
		ResourceModel.ResourceType.WOOD: ResourceModel.new(ResourceModel.ResourceType.WOOD, 100),
		ResourceModel.ResourceType.STONE: ResourceModel.new(ResourceModel.ResourceType.STONE, 100),
		ResourceModel.ResourceType.GOLD: ResourceModel.new(ResourceModel.ResourceType.GOLD, 0, 0, 7),
		ResourceModel.ResourceType.SOLDIER: ResourceModel.new(ResourceModel.ResourceType.SOLDIER, 0, 0, 0)
	}
	

# 新增数据访问方法
func get_resource(type: ResourceModel.ResourceType) -> ResourceModel:
	return resources.get(type, null)

func get_all_resources():
	return resources.values()

func update_resource(res: ResourceModel):
	if resources.has(res.type): 
		resources[res.type] = res

func get_resource_amount(type: ResourceModel.ResourceType) -> int:
	return get_resource(type).amount if get_resource(type) else 0

func get_resource_capacity(type: ResourceModel.ResourceType) -> int:
	return get_resource(type).storage_capacity if get_resource(type) else 0

func get_resource_name(type: ResourceModel.ResourceType) -> String:
	return resources.get(type, null).name
