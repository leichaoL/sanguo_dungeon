extends Node


signal production_building_upgrade_failed(type: ProductionBuildingModel.ProductionBuildingType, fail_reason: String)
signal production_building_upgrade_success(type: ProductionBuildingModel.ProductionBuildingType)
signal resource_changed(type: ResourceModel.ResourceType, amount: int, capacity: int)
signal resource_limit_reached(type: ResourceModel.ResourceType)
signal try_upgrade_production_building(type: ProductionBuildingModel.ProductionBuildingType)
signal confirm_upgrade_production_building(type: ProductionBuildingModel.ProductionBuildingType)
signal recruit_solider()
signal recruit_failed()
