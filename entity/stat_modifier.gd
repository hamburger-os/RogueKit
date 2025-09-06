# 属性修改器
# 一个轻量级的数据对象，定义了一个具体的属性修改。
class_name StatModifier
extends Object

# 修改器的类型
enum ModifierType {
	ADDITIVE,       # 加法
	MULTIPLICATIVE, # 乘法 (最终值乘以 (1 + value))
}

# 修改的数值
var value: float
# 修改的类型
var type: ModifierType
# 持续时间 (0 表示永久)
var duration: float

func _init(p_value: float, p_type: ModifierType, p_duration: float = 0.0):
	self.value = p_value
	self.type = p_type
	self.duration = p_duration