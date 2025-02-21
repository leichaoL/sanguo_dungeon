extends PanelContainer

@onready var food_label: Label = $MarginContainer/TopBar/FoodLabel
@onready var wood_label: Label = $MarginContainer/TopBar/WoodLabel
@onready var stone_label: Label = $MarginContainer/TopBar/StoneLabel
@onready var gold_label: Label = $MarginContainer/TopBar/GoldLabel

@onready var food: TextureRect = $MarginContainer/TopBar/Food
@onready var wood: TextureRect = $MarginContainer/TopBar/Wood
@onready var stone: TextureRect = $MarginContainer/TopBar/Stone
@onready var gold: TextureRect = $MarginContainer/TopBar/Gold


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# 初始化
	_on_refresh_resources(ResourceModel.ResourceType.FOOD, resource_manager.get_resource_amount(ResourceModel.ResourceType.FOOD), resource_manager.get_resource_capacity(ResourceModel.ResourceType.FOOD))
	_on_refresh_resources(ResourceModel.ResourceType.WOOD, resource_manager.get_resource_amount(ResourceModel.ResourceType.WOOD), resource_manager.get_resource_capacity(ResourceModel.ResourceType.WOOD))
	_on_refresh_resources(ResourceModel.ResourceType.STONE, resource_manager.get_resource_amount(ResourceModel.ResourceType.STONE), resource_manager.get_resource_capacity(ResourceModel.ResourceType.STONE))
	_on_refresh_resources(ResourceModel.ResourceType.GOLD, resource_manager.get_resource_amount(ResourceModel.ResourceType.GOLD), resource_manager.get_resource_capacity(ResourceModel.ResourceType.GOLD))


	# 监听资源变化信号
	EventBus.resource_changed.connect(_on_refresh_resources)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	pass

func _on_refresh_resources(type: ResourceModel.ResourceType, amount: int, capacity: int) -> void:
	'''接收信号刷新资源数量'''
	#var building_type := resource_manager.get_production_building_type(type)
	#var production_rate := production_building_manager.get_production_building_production_rate(building_type)
	#var res_name := resource_manager.get_resouce_name(type)
	#tooltip_text = '%s, 生产速度：%d/s' %[res_name, production_rate]
	#print(tooltip_text)
	match type:
		ResourceModel.ResourceType.FOOD:
			food_label.text = str(amount) + "/" + str(capacity)
			#food_label.tooltip_text = tooltip_text
			#food.tooltip_text = tooltip_text
		ResourceModel.ResourceType.WOOD:
			wood_label.text = str(amount) + "/" + str(capacity)
			#wood_label.tooltip_text = tooltip_text
			#wood.tooltip_text = tooltip_text
		ResourceModel.ResourceType.STONE:
			stone_label.text = str(amount) + "/" + str(capacity)
			#stone_label.tooltip_text = tooltip_text
			#stone.tooltip_text = tooltip_text
		ResourceModel.ResourceType.GOLD:
			gold_label.text = str(amount) + "/" + str(capacity)
			#gold_label.tooltip_text = tooltip_text
			#gold.tooltip_text = tooltip_text
