# 能力管理器组件
# 负责管理、组装和执行一个实体所拥有的能力。
class_name AbilityManagerComponent
extends Node

@export var ability_core: AbilityCoreData

var applied_modifiers: Array[AbilityModifierData] = []

# 应用一个新的修饰符
func apply_modifier(modifier: AbilityModifierData):
	# 检查标签兼容性
	for required_tag in modifier.tags_required:
		if not ability_core.tags.has(required_tag):
			push_warning("Failed to apply modifier '{modifier_name}'. Core is missing required tag: '{required_tag}'".format({
				"modifier_name": modifier.modifier_name,
				"required_tag": required_tag
			}))
			return
	
	applied_modifiers.append(modifier)
	# (可以在这里发出一个信号，通知UI更新等)

# 执行能力
func execute_ability(target: Node):
	if not ability_core:
		push_warning("No AbilityCoreData assigned to AbilityManagerComponent.")
		return
	
	var all_effects: Array[EffectData] = []
	all_effects.append_array(ability_core.effects)
	for modifier in applied_modifiers:
		all_effects.append_array(modifier.effects_to_add)
		
	var attacker = get_owner()
	var context = EffectContext.new(attacker, target, ability_core)
	
	for effect in all_effects:
		effect.execute(context)
