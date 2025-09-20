# 能力组件
# 管理一个实体的能力列表，并负责执行这些能力。
class_name AbilityComponent
extends Node

# No longer need to preload GameManager here, as it's a global singleton.

# 实体拥有的所有能力
@export var abilities: Array[AbilityData] = []

# 获取默认的主动能力（通常是第一个）
func get_primary_ability() -> AbilityData:
	if not abilities.is_empty():
		return abilities[0]
	return null

# 执行能力
# @param ability [AbilityData]: 要执行的能力。
# @param target [Node]: 效果作用的目标。
func execute_ability(ability: AbilityData, target: Node):
	# 使用 RealTimeLoopManager (如果存在) 来处理冷却
	if RealTimeLoopManager and not RealTimeLoopManager.is_ability_ready(get_owner(), ability):
		print(ability.ability_name + " is on cooldown.")
		return

	print(get_owner().name + " uses ability: " + ability.ability_name)

	var context = EffectContext.new(get_owner(), target, ability, {}, GameManager)
	
	# --- 效果链处理 ---
	# 阶段 1: 首先执行所有伤害效果
	for effect in ability.effects:
		if effect is DamageEffect:
			effect.execute(context)
			
	# 阶段 2: 然后执行所有其他效果（如吸血、施加状态等）
	# 这些效果现在可以从 context.metadata["damage_dealt"] 中获取伤害值
	for effect in ability.effects:
		if not (effect is DamageEffect):
			effect.execute(context)

	# 2. 设置冷却时间
	if RealTimeLoopManager and ability.cooldown > 0:
		RealTimeLoopManager.start_cooldown(get_owner(), ability)