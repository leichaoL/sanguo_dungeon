extends Node

class_name ResourceRepository

var resources: Dictionary = {}

func _init() -> void:

	resources = {
		ResourceModel.ResourceType.FOOD: ResourceModel.new(),
		ResourceModel.ResourceType.WOOD: ResourceModel.new(),
		ResourceModel.ResourceType.STONE: ResourceModel.new(),
		ResourceModel.ResourceType.GOLD: ResourceModel.new()
    }
    

    # 初始化资源数量
	resources[ResourceModel.ResourceType.FOOD].amount = 1000
	resources[ResourceModel.ResourceType.WOOD].amount = 1000
	resources[ResourceModel.ResourceType.STONE].amount = 1000
	resources[ResourceModel.ResourceType.GOLD].amount = 0
    

# 新增数据访问方法
func get_resource(type: ResourceModel.ResourceType) -> ResourceModel:
	return resources.get(type, null)

func get_all_resources() -> Array[ResourceModel]:
	return resources.values()

func update_resource(res: ResourceModel):
	if resources.has(res.type):
		resources[res.type] = res

func get_resource_amount(type: ResourceModel.ResourceType) -> int:
	return get_resource(type).amount if get_resource(type) else 0