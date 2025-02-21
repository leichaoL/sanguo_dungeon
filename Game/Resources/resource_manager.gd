extends Node

class_name ResourceManager 

@onready var production_timer: Timer = Timer.new()

var resource_repository: ResourceRepository = ResourceRepository.new()
var refresh_time: float = 3.0

func _ready() -> void:
	# 初始化生产计时器
	add_child(production_timer)
	production_timer.wait_time = refresh_time
	production_timer.timeout.connect(_on_production_timer_timeout)
	production_timer.start()

	# 监听生产建筑升级成功事件，更新生产速率和存储容量
	EventBus.production_building_upgrade_success.connect(_on_production_building_upgrade_success)
	EventBus.recruit_solider.connect(_on_recruit_solider)
	
# 封装数据访问方法
func get_resource(type: ResourceModel.ResourceType) -> ResourceModel:
	return resource_repository.get_resource(type)

func get_resource_amount(type: ResourceModel.ResourceType) -> int:
	return resource_repository.get_resource_amount(type)

func get_all_resources():
	return resource_repository.get_all_resources()

func update_resource(res: ResourceModel) -> void:
	resource_repository.update_resource(res)


func get_resource_capacity(type: ResourceModel.ResourceType) -> int:
	return resource_repository.get_resource_capacity(type)

func get_resouce_name(type: ResourceModel.ResourceType) -> String:
	return resource_repository.get_resource_name(type)

# 新增资源
func add_resource(type: ResourceModel.ResourceType, amount: int) -> void:
	
	var res = get_resource(type)
	
	var new_amount = res.amount + amount
	print("招募数量%d，新数量%d，限额%d" %[amount, new_amount, res.storage_capacity])
	if new_amount >= res.storage_capacity:
	
		EventBus.resource_limit_reached.emit(type)
		new_amount = res.storage_capacity
	res.amount = new_amount
	update_resource(res)
	EventBus.resource_changed.emit(type, res.amount, res.storage_capacity)
	print(new_amount)
	
# 消耗资源
func remove_resource(type: ResourceModel.ResourceType, amount: int) -> void:
	var res = get_resource(type)
	res.amount -= amount
	update_resource(res)
	EventBus.resource_changed.emit(type, res.amount, res.storage_capacity)



# 生产资源
func produce_resource() -> void:
	for resource_type in resource_repository.resources:
		var building_type: ProductionBuildingModel.ProductionBuildingType = get_production_building_type(resource_type)
		var produce_rate = production_building_manager.get_production_building_production_rate(building_type)
		var produce_amount = produce_rate * refresh_time
		add_resource(resource_type, produce_amount)


# 根据资源类型返回对应的生产建筑类型
func get_production_building_type(resource_type: ResourceModel.ResourceType) -> ProductionBuildingModel.ProductionBuildingType:
	match resource_type:
		ResourceModel.ResourceType.FOOD:
			return ProductionBuildingModel.ProductionBuildingType.FARM
		ResourceModel.ResourceType.WOOD:
			return ProductionBuildingModel.ProductionBuildingType.LOGGING_CAMP
		ResourceModel.ResourceType.STONE:
			return ProductionBuildingModel.ProductionBuildingType.QUARRY
		ResourceModel.ResourceType.GOLD:
			return ProductionBuildingModel.ProductionBuildingType.MINING_SITE
		_:
			return ProductionBuildingModel.ProductionBuildingType.BARRACKS

func get_resource_type_by_production_building_type(production_building_type: ProductionBuildingModel.ProductionBuildingType) -> ResourceModel.ResourceType:
	match production_building_type:
		ProductionBuildingModel.ProductionBuildingType.FARM:
			return ResourceModel.ResourceType.FOOD
		ProductionBuildingModel.ProductionBuildingType.LOGGING_CAMP:
			return ResourceModel.ResourceType.WOOD
		ProductionBuildingModel.ProductionBuildingType.QUARRY:
			return ResourceModel.ResourceType.STONE
		ProductionBuildingModel.ProductionBuildingType.MINING_SITE:
			return ResourceModel.ResourceType.GOLD
		_:
			return ResourceModel.ResourceType.SOLDIER

func _on_production_timer_timeout() -> void:
	produce_resource()
	get_all_resources()


func _on_production_building_upgrade_success(building_type: ProductionBuildingModel.ProductionBuildingType) -> void:
	# 生产建筑升级成功后，更新生产速率和存储容量
	var production_building = production_building_manager.get_production_building(building_type)
	
	var production_rate = production_building_manager.get_production_building_production_rate(building_type)
	var storage_capacity = production_building_manager.get_production_building_storage_capacity(building_type)
	
	var res = get_resource(get_resource_type_by_production_building_type(building_type))
	
	res.production_rate = production_rate
	res.storage_capacity = storage_capacity
	update_resource(res)
	EventBus.resource_changed.emit(res.type, res.amount, res.storage_capacity)

func _on_recruit_solider():
	
	var type = ResourceModel.ResourceType.SOLDIER
	var cap = get_resource_capacity(type)
	add_resource(type, 500)
	
