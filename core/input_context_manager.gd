# 输入上下文管理器
# 负责在不同的游戏状态下启用或禁用不同的输入动作。
# 例如，在游戏主循环中启用 "move_left", "attack" 等动作，
# 而在打开库存界面时，禁用这些动作，并启用 "navigate_up", "select_item" 等。
class_name InputContextManager
extends Node

# 存储所有已定义的上下文及其包含的动作
# 格式: { "context_name": ["action1", "action2"] }
var _contexts: Dictionary = {}

# 当前激活的上下文
var _active_contexts: Array[String] = []


# 定义一个新的输入上下文
func define_context(context_name: String, actions: Array[String]):
	_contexts[context_name] = actions


# 激活一个或多个上下文
func activate_contexts(context_names: Array[String]):
	# 首先禁用所有当前动作
	_disable_all_actions()
	
	_active_contexts = context_names
	for context_name in _active_contexts:
		if _contexts.has(context_name):
			for action in _contexts[context_name]:
				InputMap.get_singleton().action_set_enabled(action, true)


# 禁用所有已定义的上下文中的所有动作
func _disable_all_actions():
	for context_name in _contexts.keys():
		for action in _contexts[context_name]:
			# Godot 4 doesn't have a direct `is_action_enabled` equivalent.
			# The logic is to just disable all known actions.
			InputMap.get_singleton().action_set_enabled(action, false)

# 辅助方法：在游戏启动时调用，以确保所有动作初始为禁用状态
func disable_all_at_boot():
	for context_name in _contexts.keys():
		for action in _contexts[context_name]:
			InputMap.get_singleton().action_set_enabled(action, false)