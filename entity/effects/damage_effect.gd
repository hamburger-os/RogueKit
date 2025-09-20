# 伤害效果
# 继承自 EffectData，实现对目标造成伤害的逻辑。
class_name DamageEffect
extends EffectData

# 基础伤害值
@export var base_damage: int = 10

# 伤害类型 (未来可用于计算抗性等)
# enum DamageType { PHYSICAL, FIRE, ICE }
# @export var damage_type: DamageType = DamageType.PHYSICAL


# 重写 execute 方法
func execute(context: EffectContext):
	if not context or not is_instance_valid(context.target):
		return

	var target = context.target
	var attacker = context.attacker
	
	var final_damage = base_damage
	
	# 从攻击者处获取属性加成
	if is_instance_valid(attacker):
		var stats_comp = attacker.find_child("StatsComponent", true, false)
		if stats_comp and stats_comp.get_stat("damage_multiplier"):
			final_damage *= stats_comp.get_stat_value("damage_multiplier")

	var health_comp = target.find_child("HealthComponent", true, false)
	if health_comp:
		health_comp.take_damage(int(final_damage))
		
		# 将实际造成的伤害值写入上下文，供后续效果（如吸血）使用
		context.metadata["damage_dealt"] = int(final_damage)