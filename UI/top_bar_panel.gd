extends PanelContainer

@onready var food_label: Label = $MarginContainer/TopBar/FoodLabel
@onready var wood_label: Label = $MarginContainer/TopBar/WoodLabel
@onready var stone_label: Label = $MarginContainer/TopBar/StoneLabel
@onready var gold_label: Label = $MarginContainer/TopBar/GoldLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	refresh_resources_num()
	
func refresh_resources_num() -> void:
	'''刷新资源数量'''
	
	var resources = GameManager.get_resources()
	var food_num = resources.get('food')
	var wood_num = resources.get('wood')
	var stone_num = resources.get('stone')
	var gold_num = resources.get('gold')
	
	
	food_label.text = str(food_num) 
	wood_label.text = str(wood_num)
	stone_label.text = str(stone_num)
	gold_label.text = str(gold_num)
