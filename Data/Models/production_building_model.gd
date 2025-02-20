extends Resource

class_name ProductionBuildingModel

enum ProductionBuildingType {
	FARM,
	LOGGING_CAMP,
	QUARRY,
	MINING_SITE
}

@export var type: ProductionBuildingType
@export var level: int = 1
@export var upgrade_cost: Dictionary = {}
@export var production_rate: Dictionary = {}
@export var storage_capacity: Dictionary = {}