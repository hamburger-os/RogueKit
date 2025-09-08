# Selector 节点
# 按顺序执行其子节点。如果任何一个子节点返回 SUCCESS 或 RUNNING，
# 它会立即停止并返回该状态。只有当所有子节点都返回 FAILURE 时，它才返回 FAILURE。
class_name SelectorNode
extends BehaviorNode

@export var children: Array[BehaviorNode] = []

func tick(context: Node) -> Status:
	for child in children:
		var child_status = child.tick(context)
		if child_status != Status.FAILURE:
			return child_status
	
	return Status.FAILURE