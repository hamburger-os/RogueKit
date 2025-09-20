# AI 组件
# 附加到实体上，负责加载并执行行为树，从而为实体生成行动。
class_name AIComponent
extends Node

# 对 AI 行为配置文件的引用
@export var ai_profile: AIBehaviorProfile

# 黑板，用于在行为树的不同节点之间共享数据。
# 例如: {"target_entity": player_node, "last_known_position": Vector2(10, 5)}
var blackboard: Dictionary = {}


# 由 Entity 的 take_turn() 调用，用于获取此 AI 在当前回合的行动
func get_action() -> BaseAction:
	if not ai_profile or not ai_profile.root_node:
		push_warning("AIComponent has no valid AIBehaviorProfile assigned.")
		return null # 返回一个空行动，让实体跳过此回合

	# 在每个回合开始时，清空黑板中的上一回合的临时数据
	# 注意：我们可能希望保留一些长期记忆，这里为了简单起见，全部清空。
	blackboard.clear()
	
	# 设置上下文：将 AI 组件自身传递给行为树节点，以便它们可以访问 owner
	ai_profile.root_node.context = self
	
	# 执行行为树
	var status = ai_profile.root_node.tick(get_owner(), blackboard)
	
	# 从黑板中提取生成的行动
	if blackboard.has("action") and blackboard.action is BaseAction:
		return blackboard.action
	
	# 如果行为树没有生成行动（例如，AI 决定等待），则返回 null
	return null