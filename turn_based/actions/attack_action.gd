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
	# --- 1. 验证目标和组件 ---
	if not is_instance_valid(target):
		print(entity.name + " attack failed: target is invalid.")
		return

	var attacker_stats: StatsComponent = entity.get_node_or_null("StatsComponent")
	var target_stats: StatsComponent = target.get_node_or_null("StatsComponent")
	var target_health: HealthComponent = target.get_node_or_null("HealthComponent")

	if not target_health:
		print(entity.name + " attack failed: target has no HealthComponent.")
		return

	# --- 2. 伤害计算 ---
	# 默认值
	var attack_power = 1 
	var defense_power = 0

	# 获取攻击力
	if attacker_stats:
		attack_power = attacker_stats.get_stat_value("strength") # 使用 "strength" 作为攻击属性
	else:
		push_warning(entity.name + " has no StatsComponent for attack calculation.")

	# 获取防御力
	if target_stats:
		defense_power = target_stats.get_stat_value("defense") # 使用 "defense" 作为防御属性

	# 计算最终伤害：确保伤害至少为1，防止无效攻击或治疗效果
	var damage = max(1, attack_power - defense_power)

	# --- 3. 应用伤害 ---
	print(entity.name + " attacks " + target.name + " for " + str(damage) + " damage.")
	target_health.take_damage(damage)