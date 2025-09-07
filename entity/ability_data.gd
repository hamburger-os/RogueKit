# 能力数据资源
# 定义一个能力（技能）的所有属性和效果。
class_name AbilityData
extends Resource

@export_group("Metadata")
@export var ability_name: String = "Ability"
@export var icon: Texture2D
@export var description: String = ""

@export_group("Mechanics")
# 冷却时间（秒）。注意：对于回合制游戏，冷却时间可能需要以回合数为单位，
# 这需要TurnManager在回合结束时减少冷却计数。当前实现为实时秒数。
@export var cooldown: float = 0.0 
@export var energy_cost: int = 100 # 消耗的行动能量

# 能力触发时执行的效果列表
@export var effects: Array[EffectData] = []

# --- 目标选择参数 ---
# (未来可以添加: range, area_of_effect_shape, target_type, etc.)