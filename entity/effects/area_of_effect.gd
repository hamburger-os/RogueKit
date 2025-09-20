# 范围效果
# 在一个区域内，对所有符合条件的目标应用一个或多个子效果。
class_name AreaOfEffect
extends EffectData

# 效果的作用范围（半径）
@export var radius: float = 100.0

# 效果作用的形状
enum AreaShape {
	CIRCLE,
	BOX
}
@export var shape: AreaShape = AreaShape.CIRCLE
@export var box_extents: Vector2 # for BOX shape

# 要在范围内应用的效果列表
@export var sub_effects: Array[EffectData]

# 最大目标数量 (0表示无限制)
@export var max_targets: int = 0

# 目标筛选：需要匹配的实体分组
@export var target_groups: Array[String] = ["enemies"]


func execute(context: EffectContext):
	if sub_effects.is_empty():
		push_warning("AreaOfEffect has no sub_effects to apply.")
		return

	var world = context.attacker.get_world_2d()
	var space_state = world.direct_space_state
	
	var query = PhysicsShapeQueryParameters2D.new()
	
	var shape_rid
	if shape == AreaShape.CIRCLE:
		var circle_shape = CircleShape2D.new()
		circle_shape.radius = radius
		shape_rid = circle_shape
	else: # BOX
		var box_shape = RectangleShape2D.new()
		box_shape.size = box_extents
		shape_rid = box_shape

	query.set_shape(shape_rid)
	query.transform = Transform2D(0, context.target.global_position)
	
	var results = space_state.intersect_shape(query)
	
	var targets_found = 0
	for result in results:
		if max_targets > 0 and targets_found >= max_targets:
			break
			
		var collider = result.collider
		if not is_instance_valid(collider):
			continue
		
		# 检查分组
		var is_valid_target = false
		for group in target_groups:
			if collider.is_in_group(group):
				is_valid_target = true
				break
		
		if not is_valid_target:
			continue
			
		# 创建新的上下文，将当前找到的实体作为新目标
		var sub_context = EffectContext.new(
			context.attacker,
			collider,
			context.source_ability,
			context.metadata,
			context.game_manager
		)
		
		# 应用所有子效果
		for effect in sub_effects:
			effect.execute(sub_context)
			
		targets_found += 1