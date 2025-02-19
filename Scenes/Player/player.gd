extends CharacterBody2D

const SPEED = 300.0
var curAnimation = 'idle'
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var near_castle = false


func _physics_process(delta: float) -> void:
	var input_direction = Vector2.ZERO
	var newAnimation = curAnimation
	
	# 获取输入方向
	input_direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	# 根据输入方向设置动画
	if input_direction.x < 0:
		newAnimation = 'ani_left'
	elif input_direction.x > 0:
		newAnimation = 'ani_right'
	if input_direction.y < 0:
		newAnimation = 'ani_up'
	elif input_direction.y > 0:
		newAnimation = 'ani_down'
	
	# 标准化速度并应用移动
	if input_direction.length() > 0:
		velocity = input_direction.normalized() * SPEED
	else:
		velocity = Vector2.ZERO  # 没有输入时停止移动
	
	# 使用引擎的移动方法
	move_and_slide()
	
	# 更新动画状态
	updateAnimation(newAnimation, input_direction != Vector2.ZERO)

func updateAnimation(newAnimation: String, is_moving: bool) -> void:
	
	if is_moving and curAnimation != newAnimation:
		animated_sprite_2d.play(newAnimation)
		curAnimation = newAnimation
	elif not is_moving:
		animated_sprite_2d.play('idle')
		curAnimation = 'idle'
