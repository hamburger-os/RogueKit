# Action_Wait 节点
# 一个简单的叶节点，它什么都不做，只是成功。
# 在行为树中，这可以用来实现一个“空闲”或“等待”的行为。
class_name Action_Wait
extends BehaviorNode

func tick(context: Node) -> Status:
	# 这个叶节点不生成任何具体的 BaseAction，
	# 它的效果就是让 AIComponent 返回 null，从而使实体跳过一回合。
	# 这在行为树中是完全有效的行为。
	return Status.SUCCESS