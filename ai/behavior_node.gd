# 行为树节点基类
# 这是行为树中所有节点（组合、装饰、叶节点）的父类。
class_name BehaviorNode
extends Resource

# 行为树节点的执行状态
enum Status {SUCCESS, FAILURE, RUNNING}

# 节点的执行上下文，通常是AI组件本身
var context: Node

# 核心方法，所有子类都必须重写此方法以实现其逻辑。
# @return [Status]: 返回节点的执行结果。
func tick(actor: Node, blackboard: Dictionary) -> Status:
	push_error("BehaviorNode.tick(actor, blackboard) is not implemented. Please override it in the child class.")
	return Status.FAILURE