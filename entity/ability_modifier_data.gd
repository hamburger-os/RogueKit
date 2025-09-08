# 能力修饰符数据资源
# 定义一个可以附加到 AbilityCoreData 上的修改逻辑。
class_name AbilityModifierData
extends Resource

@export_group("Metadata")
@export var modifier_name: String = "Modifier"
@export var description: String = ""

@export_group("Mechanics")
# 确保此修饰符只能附加到具有所有这些标签的能力核心上。
# 例如，一个 "多重射击" 修饰符可能需要 ["projectile"] 标签。
@export var tags_required: Array[String] = []

# 应用此修饰符时，将这些效果添加到能力核心的效果列表中。
@export var effects_to_add: Array[EffectData] = []

# (未来可以添加: stat_modifiers_to_apply, etc.)