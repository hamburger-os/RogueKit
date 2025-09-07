# 能力组件
# 管理一个实体的能力列表，并负责执行这些能力。
class_name AbilityComponent
extends Node

# 实体拥有的所有能力
@export var abilities: Array[AbilityData] = []

# 存储能力的冷却时间 {ability_resource: current_cooldown_timer}
var ability_cooldowns: Dictionary = {}

func _process(delta: float):
	# 更新冷却时间
	var abilities_to_remove = []
	for ability in ability_cooldowns:
		ability_cooldowns[ability] -= delta
		if ability_cooldowns[ability] <= 0:
			abilities_to_remove.append(ability)
	
	for ability in abilities_to_remove:
		ability_cooldowns.erase(ability)

# 检查能力是否可用（不在冷却中）
func can_use_ability(ability: AbilityData) -> bool:
	return not ability_cooldowns.has(ability)

# 执行能力
# @param ability [AbilityData]: 要执行的能力。
# @param target [Node]: 效果作用的目标。
func execute_ability(ability: AbilityData, target: Node):
	if not can_use_ability(ability):
		print(ability.ability_name + " is on cooldown.")
		return

	print(get_owner().name + " uses ability: " + ability.ability_name)

	# 1. 应用效果
	for effect in ability.effects:
		effect.execute(target)

	# 2. 设置冷却时间
	if ability.cooldown > 0:
		ability_cooldowns[ability] = ability.cooldown