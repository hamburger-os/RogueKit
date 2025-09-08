# 效果：应用属性修改器
# 将一个 StatModifier 应用到目标的 StatsComponent。
class_name ApplyStatModifierEffect
extends EffectData

# 要应用的属性修改器资源
@export var stat_modifier: StatModifier

# 要修改的目标属性名称 (例如 "strength", "defense")
@export var stat_name: String = ""

func execute(context: EffectContext):
	if not stat_modifier or stat_name.is_empty():
		push_warning("ApplyStatModifierEffect is missing a stat_modifier or stat_name.")
		return

	var stats_component: StatsComponent = context.target.get_node_or_null("StatsComponent")
	if stats_component:
		stats_component.add_modifier(stat_name, stat_modifier)
	else:
		push_warning(context.target.name + " has no StatsComponent to apply effect.")