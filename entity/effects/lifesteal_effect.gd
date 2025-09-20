# 吸血效果
# 继承自 EffectData，实现造成伤害时按比例回复攻击者生命值的逻辑。
# 这是一个如何扩展自定义效果的示例。
class_name LifestealEffect
extends EffectData

# 吸血比例 (0.0 to 1.0)
@export var lifesteal_ratio: float = 0.2

# 重写 execute 方法
func execute(context: EffectContext):
	# 确保上下文包含了我们需要的所有信息
	if not context or not is_instance_valid(context.attacker) or not context.has("damage_dealt"):
		return

	var attacker = context.attacker
	var damage_dealt = context.damage_dealt

	var attacker_health_comp = attacker.find_child("HealthComponent", true, false)
	if not attacker_health_comp:
		return

	var heal_amount = int(damage_dealt * lifesteal_ratio)
	if heal_amount > 0:
		attacker_health_comp.heal(heal_amount)
		print("%s lifesteals %d HP." % [attacker.name, heal_amount])