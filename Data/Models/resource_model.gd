extends Resource

class_name ResourceModel

enum ResourceType {
	FOOD,
	WOOD,
	STONE,
	GOLD,
	SOLDIER
}

@export var type: ResourceType
@export var name: String
@export var amount: int = 0
@export var storage_capacity: int = 1000
@export var production_rate: int = 0

func _init(res_type: ResourceType, res_amount: int = 0, res_storage_capacity: int = 1000, res_production_rate: int = 0) -> void:
	self.type = res_type
	self.amount = res_amount
	self.storage_capacity = res_storage_capacity
	self.production_rate = res_production_rate
	
	var res_name = ""
	match res_type:
		ResourceType.FOOD:
			res_name = "粮草"
		ResourceType.WOOD:
			res_name = "木材"
		ResourceType.STONE:
			res_name = "石材"
		ResourceType.GOLD:
			res_name = "黄金"
		_:
			res_name = "预备兵"
