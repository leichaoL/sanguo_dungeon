extends Resource

class_name ProductionBuildingModel

enum ProductionBuildingType {
	FARM,
	LOGGING_CAMP,
	QUARRY,
	MINING_SITE,
	BARRACKS
}

@export var type: ProductionBuildingType
@export var name: String = "未知建筑"
@export var level: int = 1
@export var base_production_rate: int = 1
@export var base_storage_capacity: int = 1000
@export var base_upgrade_cost: Dictionary = {}
@export var upgrade_conditions: Dictionary = {}


func _init(pb_type: ProductionBuildingType, pb_level: int = 1, pb_base_production_rate: int = 1, pb_base_storage_capacity: int = 1000, pb_base_upgrade_cost: Dictionary = {}, pb_upgrade_conditions: Dictionary = {}) -> void:
	self.type = pb_type
	self.level = pb_level
	self.base_production_rate = pb_base_production_rate
	self.base_storage_capacity = pb_base_storage_capacity
	self.base_upgrade_cost = pb_base_upgrade_cost
	self.upgrade_conditions = pb_upgrade_conditions
	
	var pb_name: String = ""
	match pb_type:
		ProductionBuildingType.FARM:
			pb_name = "农场"
		ProductionBuildingType.LOGGING_CAMP:
			pb_name = "伐木场"
		ProductionBuildingType.QUARRY:
			pb_name = "采石场"
		ProductionBuildingType.MINING_SITE:
			pb_name = "金矿"
		_:
			pb_name = "兵营"

	self.name = pb_name
