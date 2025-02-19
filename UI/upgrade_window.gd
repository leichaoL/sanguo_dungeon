extends Control

@onready var building: Label = $PanelContainer/MarginContainer/VBoxContainer/Title/HBoxContainer/Building
@onready var cur_production_label: Label = $PanelContainer/MarginContainer/VBoxContainer/Compare/MarginContainer/HBoxContainer/VBoxContainer/CurProduction/CurProductionLabel
@onready var next_level: Label = $PanelContainer/MarginContainer/VBoxContainer/Title/HBoxContainer/NextLevel
@onready var upgrade_production_label: Label = $PanelContainer/MarginContainer/VBoxContainer/Compare/MarginContainer/HBoxContainer/UpgradeProduction/UpgradeProductionLabel



var building_name: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func refresh_needs(build: String):
	self.building_name = build
	var building_data = GameManager.buildings.get(building_name, {})
	var current_level = building_data.get("level", 1)
	var upgrade_cost = building_data.get("upgrade_cost", {})

	# 更新建筑名称和等级显示
	match building_name:
		'farm':
			building.text = '农场'
		'wood':
			building.text = '伐木场'
		'stone':
			building.text = '采石场'
		'gold':
			building.text = '金矿'
	next_level.text = str(current_level + 1)

	# 更新生产速度
	var current_speed = GameManager.get_build_production_speed(building_name)
	var next_speed = GameManager.get_build_production_speed(building_name, current_level + 1)
	cur_production_label.text = "%s/s" %current_speed
	upgrade_production_label.text = "%s/s → %s/s" % [current_speed, next_speed]

	# 更新资源需求显示
	var resource_nodes = {
		"food": $PanelContainer/MarginContainer/VBoxContainer/Compare/MarginContainer/HBoxContainer/VBoxContainer/FoodNeeds/Label,
		"wood": $PanelContainer/MarginContainer/VBoxContainer/Compare/MarginContainer/HBoxContainer/VBoxContainer/WoodNeeds/Label,
		"stone": $PanelContainer/MarginContainer/VBoxContainer/Compare/MarginContainer/HBoxContainer/VBoxContainer/StoneNeeds/Label,
		"gold": $PanelContainer/MarginContainer/VBoxContainer/Compare/MarginContainer/HBoxContainer/VBoxContainer/GoldNeeds/Label
	}

	for resource in resource_nodes:
		var cost = upgrade_cost.get(resource, 0)
		resource_nodes[resource].text = str(cost)
		# 如果需求为0则隐藏对应资源行
		resource_nodes[resource].get_parent().visible = cost > 0


func _on_cancle_pressed() -> void:
	self.visible = false


func _on_confirm_pressed() -> void:
	GameManager.upgrade_building(building_name)
	refresh_needs(building_name)
	
