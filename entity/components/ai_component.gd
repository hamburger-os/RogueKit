# AI 组件
# 负责为实体生成行动决策。
class_name AIComponent
extends Node

@export var behavior_profile: AIBehaviorProfile

var _last_action: BaseAction = null

# 由 Entity 的 take_turn() 调用
func get_action() -> BaseAction:
	if not behavior_profile or not behavior_profile.root_node:
		push_warning("AIComponent has no behavior_profile or root_node assigned.")
		return null
	
	# 如果有上次未完成的 Action，则直接返回
	if _last_action:
		var action_to_return = _last_action
		_last_action = null
		return action_to_return
	
	# 设置所有节点的上下文
	_set_context(behavior_profile.root_node)
	
	# 执行行为树
	behavior_profile.root_node.tick(self)
	
	# 返回 tick() 过程中可能生成的 Action
	var action_to_return = _last_action
	_last_action = null
	return action_to_return


# 递归地为所有行为树节点设置上下文
func _set_context(node: BehaviorNode):
	node.context = self
	if "children" in node:
		for child in node.children:
			_set_context(child)

# 由叶节点调用，用于设置要执行的动作
func set_action(action: BaseAction):
	_last_action = action