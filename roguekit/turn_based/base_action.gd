# 行动基类 (命令模式)
# 这是所有具体行动（如移动、攻击）的父类。
# 它封装了执行一个行动所需的所有信息和逻辑。
class_name BaseAction
extends Object

# 执行此行动所需的能量消耗
var energy_cost: int = 100

# 行动所属的实体
var entity: Node

# 构造函数
func _init(p_entity: Node):
	self.entity = p_entity


# 核心方法，所有子类都必须重写此方法以实现其行动逻辑。
func execute():
	push_error("BaseAction.execute() is not implemented. Please override it in the child class.")