extends Panel

@onready var label = $Label

func _ready():
    visible = false

func show_prompt():
    visible = true
    
func hide_prompt():
    visible = false 