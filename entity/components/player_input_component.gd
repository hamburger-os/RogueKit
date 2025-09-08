# 玩家输入组件
# 监听并转换玩家输入为实体动作（Action）。
# 实现 "bump to attack" 逻辑：如果移动目标格有敌人，则转换为攻击动作。
class_name PlayerInputComponent
extends Node

const MoveAction = preload("res://lib/roguekit/turn_based/actions/move_action.gd")
const AttackAction = preload("res://lib/roguekit/turn_based/actions/attack_action.gd")

signal _action_created(action)

# 依赖注入
var game_manager: Node

func _ready():
	set_process(false)

# 由 Entity 的 take_turn() 调用
func get_action() -> BaseAction:
	# [FIX] 在无头模式下 (CI/测试), `Input` 事件永远不会发生，
	# `await _action_created` 将导致永久挂起。
	# 我们直接返回 `null` 来防止测试卡死。
	if OS.has_feature("headless"):
		return null

	set_process(true)
	var action = await _action_created
	set_process(false)
	return action

func _process(_delta):
	var direction = Vector2i.ZERO
	if Input.is_action_just_pressed("ui_up"):
		direction = Vector2i.UP
	elif Input.is_action_just_pressed("ui_down"):
		direction = Vector2i.DOWN
	elif Input.is_action_just_pressed("ui_left"):
		direction = Vector2i.LEFT
	elif Input.is_action_just_pressed("ui_right"):
		direction = Vector2i.RIGHT

	if direction != Vector2i.ZERO:
		var owner = get_owner()
		if not owner:
			push_warning("PlayerInputComponent has no owner!")
			_action_created.emit(null)
			return

		# --- Bump to Attack Logic ---
		# 1. 计算目标位置
		if not game_manager:
			push_error("GameManager not injected into PlayerInputComponent!")
			_action_created.emit(null)
			return
			
		var current_grid_pos = game_manager.get_grid_position(owner)
		var target_grid_pos = current_grid_pos + direction
		
		# 2. 检查目标位置上的实体
		var target_entity = game_manager.get_entity_at(target_grid_pos)
		
		# 3. 决策：攻击或移动
		if target_entity:
			_action_created.emit(AttackAction.new(owner, target_entity, game_manager))
		else:
			_action_created.emit(MoveAction.new(owner, direction, game_manager))
