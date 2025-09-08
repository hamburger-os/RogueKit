# Sequence 节点
# 按顺序执行其子节点。如果任何一个子节点返回 FAILURE 或 RUNNING，
# 它会立即停止并返回该状态。如果所有子节点都返回 SUCCESS，它也返回 SUCCESS。
class_name SequenceNode
extends BehaviorNode

@export var children: Array[BehaviorNode] = []

func tick(context: Node) -> Status:
	for child in children:
		var child_status = child.tick(context)
		if child_status != Status.SUCCESS:
			return child_status
	
	return Status.SUCCESS