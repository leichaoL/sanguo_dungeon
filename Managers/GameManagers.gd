extends Node  

# 在类作用域顶部声明信号
signal building_upgraded(building_name: String)

# 资源系统
var resources: Dictionary = {
	'food': 1000,
	'wood': 1000,
	'stone': 1000,
	'gold': 1000
}


# 英雄系统
var city_heroes: Array = []
var party: Array = []        # 最大3人
var materials: Dictionary = {}
var consumables: Dictionary = {
	"探索卡": 10
}

# 探索系统
var explored_areas: int = 0
var current_enemies: Array = []

# 建筑系统
var buildings: Dictionary = {
	"farm": {
		"level": 1,
		"base_cost": {"food": 30, "wood": 20, "stone": 10},
		"upgrade_cost": {"food": 30, "wood": 20, "stone": 10},
		"base_production": {"food": 10},
		"production": {"food": 10},
		"unlocked": true
	},
	"wood": {
		"level": 1,
		"base_cost": {"wood": 30, "stone": 15},
		"upgrade_cost": {"wood": 30, "stone": 15},
		"base_production": {"wood": 8},
		"production": {"wood": 8},
		"unlocked": true
	},
	"stone": {
		"level": 1,
		"base_cost": {"wood": 40, "stone": 20},
		"upgrade_cost": {"wood": 40, "stone": 20},
		"base_production": {"stone": 5},
		"production": {"stone": 5},
		"unlocked": true
	},
	"gold": {
		"level": 1,
		"base_cost": {"wood": 50, "stone": 30},
		"upgrade_cost": {"wood": 50, "stone": 30},
		"base_production": {"gold": 7},
		"production": {"gold": 7},
		"unlocked": false,
		"unlock_condition": {"stone": 2}
	},
}

# 军事系统
var _base_max_reserve: int = 1000
var reserve_troops: int = 0
var recruit_cost: int = 100
var recruit_amount: int = 500

var refresh_time := 3.0
@onready var production_timer = Timer.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_child(production_timer)
	production_timer.wait_time = refresh_time
	production_timer.timeout.connect(_on_production_timer_timeout)
	production_timer.start()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

	
func get_resources():
	return resources

func _on_production_timer_timeout():
	resources['food'] += get_build_production_speed('farm') * refresh_time
	resources['wood'] += get_build_production_speed('wood') * refresh_time
	resources['stone'] += get_build_production_speed('stone') * refresh_time
	resources['gold'] += get_build_production_speed('gold') * refresh_time


func get_build_production_speed(building_name: String, level: int = -1) -> int:
	var building = buildings.get(building_name)
	
	# 有效性检查
	if not building: 
		return 0
	if not building.get("unlocked", false):
		return 0
	
	# 获取实际等级（如果未指定则使用当前等级）
	var actual_level = level if level > 0 else building.get("level", 1)
	if actual_level <= 0:
		return 0
	
	# 直接返回生产值（已包含等级加成）
	var base_production_values = building.get("base_production", {}).values()
	if base_production_values.is_empty():
		return 0
	return base_production_values[0] * actual_level  # 假设生产速度随等级线性增长

func get_building_level(building_name: String) -> int:
	
	var building = buildings.get(building_name)
	return building["level"]

func get_build_upgrade_needs(building_name: String) -> Dictionary:
	
	var building = buildings.get(building_name)
	
	# 有效性检查
	if not building: 
		return {}
	if not building.get("unlocked", false):
		return {}
	if building.level <= 0:
		return {}
	
	return building.get('base_cost')


func upgrade_building(building_name: String) -> void:
	var building = buildings.get(building_name)
	
	# 有效性检查
	if not building: 
		return
	if not building.get("unlocked", false):
		return
	if building.level <= 0:
		return
	
	# 获取升级需求
	var upgrade_needs = get_build_upgrade_needs(building_name)
	
	# 检查资源是否足够
	for resource in upgrade_needs:
		if resources.get(resource, 0) < upgrade_needs[resource]:
			return  # 资源不足时直接返回
	
	# 扣除资源
	for resource in upgrade_needs:
		resources[resource] -= upgrade_needs[resource]
	
	# 升级建筑
	building["level"] += 1
	
	# 更新下次升级需求（基础成本 × 当前等级）
	var current_level = building["level"]  # 使用升级后的等级
	var multiplied_cost = {}
	for resource in building["base_cost"]:
		multiplied_cost[resource] = building["base_cost"][resource] * current_level
	building["upgrade_cost"] = multiplied_cost

	# 更新生产速度（基础生产 × 当前等级）
	var new_production = {}
	for resource in building["base_production"]:
		new_production[resource] = building["base_production"][resource] * current_level
	building["production"] = new_production

	# 发送信号
	building_upgraded.emit(building_name)
