# 武器数据
# 继承自 EquipmentData，用于定义武器。
class_name WeaponData
extends EquipmentData

@export_group("Weapon Stats")
# 武器的基础伤害值
@export var damage: int = 1

# 武器的攻击速度（例如，每秒攻击次数）
@export var attack_speed: float = 1.0

# 武器可能附带的特殊能力（例如，一个定义了火球术的 AbilityData）
@export var ability: AbilityData