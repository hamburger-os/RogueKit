# 属性修改器
# 一个轻量级的数据对象，定义了一个具体的属性修改。
class_name StatModifier
extends Resource

# 修改器的类型
enum ModifierType {
	ADDITIVE,       # 加法
	MULTIPLICATIVE, # 乘法 (最终值乘以 (1 + value))
}

enum DurationType {
	PERMANENT, # 永久
	REALTIME,  # 实时（秒）
	TURNS      # 回合数
}

# 修改的数值
var value: float
# 修改的类型
var type: ModifierType

# 持续时间相关
var duration: float = 0.0
var duration_type: DurationType = DurationType.PERMANENT

func _init(p_value: float = 0.0, p_type: ModifierType = ModifierType.ADDITIVE, p_duration: float = 0.0, p_duration_type: DurationType = DurationType.PERMANENT):
	self.value = p_value
	self.type = p_type
	self.duration = p_duration
	self.duration_type = p_duration_type