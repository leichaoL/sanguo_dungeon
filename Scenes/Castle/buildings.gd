extends Control
@onready var confirmation_dialog: ConfirmationDialog = $ConfirmationDialog
@onready var upgrade_window: Control = $UpgradeWindow

# 新增等级标签引用
@onready var farm_lvl_label: Label = get_node("Production/Production/FarmContanier/HBoxContainer/LvlLabel")
@onready var wood_lvl_label: Label = get_node("Production/Production/WoodContanier/HBoxContainer/LvlLabel")
@onready var stone_lvl_label: Label = get_node("Production/Production/StoneContanier/HBoxContainer/LvlLabel")
@onready var gold_lvl_label: Label = get_node("Production/Production/GoldContanier/HBoxContainer/LvlLabel")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# 初始化时刷新所有等级显示
	refresh_all_levels()
	# 连接升级信号
	GameManager.building_upgraded.connect(_on_building_upgraded)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	pass
	

func _on_back_to_main_pressed() -> void:
	self.get_tree().change_scene_to_file("res://Scenes/Maps/main_map.tscn")



func _on_farm_pressed() -> void:
	upgrade_window.refresh_needs("farm")
	upgrade_window.visible = true
	
	
 
func _on_wood_pressed() -> void:
	upgrade_window.refresh_needs("wood")
	upgrade_window.visible = true


func _on_stone_pressed() -> void:
	upgrade_window.refresh_needs("stone")
	upgrade_window.visible = true


func _on_gold_pressed() -> void:
	upgrade_window.refresh_needs("gold")
	upgrade_window.visible = true

func refresh_all_levels() -> void:
	
	farm_lvl_label.text = "等级：%d" % GameManager.get_building_level("farm")
	wood_lvl_label.text = "等级：%d" % GameManager.get_building_level("wood")
	stone_lvl_label.text = "等级：%d" % GameManager.get_building_level("stone")
	gold_lvl_label.text = "等级：%d" % GameManager.get_building_level("gold")

func _on_building_upgraded(building_name: String) -> void:
	# 当收到升级信号时刷新对应建筑等级
	match building_name:
		"farm":
			farm_lvl_label.text = "等级：%d" % GameManager.get_building_level("farm")
		"wood":
			wood_lvl_label.text = "等级：%d" % GameManager.get_building_level("wood")
		"stone":
			stone_lvl_label.text = "等级：%d" % GameManager.get_building_level("stone")
		"gold":
			gold_lvl_label.text = "等级：%d" % GameManager.get_building_level("gold")
