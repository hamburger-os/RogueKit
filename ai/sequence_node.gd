# Sequence 节点
# 按顺序执行其子节点。如果任何一个子节点返回 FAILURE 或 RUNNING，
# 它会立即停止并返回该状态。只有当所有子节点都返回 SUCCESS 时，它才返回 SUCCESS。
class_name SequenceNode
extends BehaviorNode

@export var children: Array[BehaviorNode] = []

func tick(actor: Node, blackboard: Dictionary) -> Status:
	for child in children:
		var child_status = child.tick(actor, blackboard)
		if child_status != Status.SUCCESS:
			return child_status
	
	return Status.SUCCESS