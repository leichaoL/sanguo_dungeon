extends Resource

class_name ResourceModel

enum ResourceType {
	FOOD,
	WOOD,
	STONE,
	GOLD
}

@export var type: ResourceType
@export var amount: int = 0
@export var storage_capacity: int = 1000
@export var production_rate: int = 0


