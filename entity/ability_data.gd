# 能力核心数据资源
# 定义一个能力的基础行为和属性。
class_name AbilityCoreData
extends Resource

@export_group("Metadata")
@export var core_name: String = "Core"
@export var icon: Texture2D
@export var description: String = ""
@export var tags: Array[String] = [] # 例如 ["projectile", "fire"]

@export_group("Mechanics")
# 冷却时间（秒）。
@export var cooldown: float = 0.0

# 能力触发时执行的效果列表
@export var effects: Array[EffectData] = []

# (未来可以添加: range, area_of_effect_shape, target_type, etc.)