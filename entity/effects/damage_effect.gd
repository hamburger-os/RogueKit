# 效果：造成伤害
# 对目标的 HealthComponent 施加一定量的伤害。
class_name DamageEffect
extends EffectData

# 伤害值
@export var damage_amount: int = 5
# 伤害类型（未来可用于抗性计算）
# enum DamageType { PHYSICAL, FIRE, ICE }
# @export var damage_type: DamageType = DamageType.PHYSICAL

func execute(context: EffectContext):
	if damage_amount <= 0:
		return

	var health_component: HealthComponent = context.target.get_node_or_null("HealthComponent")
	if health_component:
		health_component.take_damage(damage_amount)
	else:
		push_warning(context.target.name + " has no HealthComponent to apply damage effect.")