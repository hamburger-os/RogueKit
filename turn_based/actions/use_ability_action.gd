# 使用能力行动
# 封装了实体使用一个特定能力的逻辑。
class_name UseAbilityAction
extends BaseAction

const AbilityData = preload("res://lib/roguekit/entity/ability_data.gd")
const AbilityComponent = preload("res://lib/roguekit/entity/components/ability_component.gd")

var ability: AbilityData

func _init(p_ability: AbilityData):
	self.ability = p_ability
	# 实时模式下，能量消耗通常由冷却时间代替
	# 但我们仍然可以保留它，用于回合制或混合模式
	self.energy_cost = ability.energy_cost if ability else 100


func execute(owner: Node):
	if not ability:
		push_error("UseAbilityAction failed: ability is null.")
		return

	var ability_comp: AbilityComponent = owner.get_node_or_null("AbilityComponent")
	if not ability_comp:
		push_error(owner.name + " has no AbilityComponent to execute an ability.")
		return
	
	# 委托给 AbilityComponent 来执行能力
	# AbilityComponent 内部会处理效果的执行、冷却的启动等
	ability_comp.execute_ability(ability)

	print(owner.name + " used ability: " + ability.name)