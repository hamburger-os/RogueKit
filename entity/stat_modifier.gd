# 属性修改器
# 一个轻量级的数据资源，定义了一个具体的属性修改。
class_name StatModifier
extends Resource

# 修改器的类型
enum ModifierType {
	ADDITIVE,       # 加法: final_value += value
	MULTIPLICATIVE, # 乘法: final_value *= (1.0 + value)
}

# 修改器持续时间的类型
enum DurationType {
	PERMANENT, # 永久
	REALTIME,  # 实时（秒）
	TURNS,     # 回合制
}

# --- 修改器属性 ---

# 修改的数值
@export var value: float = 0.0

# 修改的类型 (加法或乘法)
@export var type: ModifierType = ModifierType.ADDITIVE

# 持续时间类型
@export var duration_type: DurationType = DurationType.PERMANENT

# 持续时间 (秒或回合数)。如果 duration_type 是 PERMANENT，此值无效。
@export var duration: float = 0.0