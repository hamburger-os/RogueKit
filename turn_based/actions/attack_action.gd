# 攻击行动
# 封装了实体攻击另一个实体的意图。
class_name AttackAction
extends BaseAction

var target: Node

func _init(p_target: Node):
	self.target = p_target
	# 攻击通常消耗一个标准回合的能量
	self.energy_cost = 100


# 执行攻击逻辑
# 委托给 owner 的 AbilityComponent 来执行默认的攻击能力。
func execute(owner: Node):
	if not is_instance_valid(owner) or not is_instance_valid(target):
		return

	var ability_comp = owner.find_child("AbilityComponent", true, false)
	if not ability_comp:
		push_warning(owner.name + " tried to attack but has no AbilityComponent.")
		return
		
	var attack_ability = ability_comp.get_primary_ability()
	if not attack_ability:
		push_warning(owner.name + " tried to attack but has no primary ability assigned.")
		return
		
	ability_comp.execute_ability(attack_ability, target)