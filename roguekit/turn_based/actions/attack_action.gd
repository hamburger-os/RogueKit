# 攻击行动
# 封装了实体攻击另一个实体的逻辑。
class_name AttackAction
extends BaseAction

var target: Node

func _init(p_entity: Node, p_target: Node):
	super._init(p_entity)
	self.target = p_target
	self.energy_cost = 100 # 假设攻击消耗100能量


func execute():
	# 在这里，我们将实现攻击逻辑。
	# 这需要从攻击者的 StatsComponent 获取攻击力，
	# 并对目标的 HealthComponent 调用 take_damage。
	
	if not is_instance_valid(target) or not target.has_node("HealthComponent"):
		print(entity.name + " has no valid target to attack.")
		return

	# 示例逻辑:
	var damage = 10 # 应该从 entity.get_node("StatsComponent").get_stat_value("attack") 获取
	print(entity.name + " attacks " + target.name + " for " + str(damage) + " damage.")
	target.get_node("HealthComponent").take_damage(damage)