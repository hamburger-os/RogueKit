# 生成场景效果
# 在指定位置实例化一个 PackedScene。常用于发射投射物、创建视觉效果等。
class_name SpawnSceneEffect
extends EffectData

# 要生成的场景
@export var scene: PackedScene

# 生成位置的偏移量
@export var offset: Vector2

# 生成的位置参考点
enum SpawnLocation {
	OWNER,       # 在效果发起者位置生成
	TARGET,      # 在效果目标位置生成
	CURSOR       # 在鼠标光标位置生成 (需要上下文提供)
}
@export var spawn_location: SpawnLocation = SpawnLocation.OWNER


func execute(context: EffectContext):
	if not scene:
		push_error("SpawnSceneEffect failed: scene is not set.")
		return

	var instance = scene.instantiate()
	
	# 确定生成位置
	var spawn_pos: Vector2
	match spawn_location:
		SpawnLocation.OWNER:
			if is_instance_valid(context.attacker):
				spawn_pos = context.attacker.global_position
			else:
				push_error("SpawnSceneEffect: Owner is invalid.")
				return
		SpawnLocation.TARGET:
			if is_instance_valid(context.target):
				spawn_pos = context.target.global_position
			else:
				push_error("SpawnSceneEffect: Target is invalid.")
				return
		SpawnLocation.CURSOR:
			if context.metadata.has("cursor_position"):
				spawn_pos = context.metadata["cursor_position"]
			else:
				push_error("SpawnSceneEffect: Cursor position not found in context.")
				return
	
	instance.global_position = spawn_pos + offset
	
	# 将实例添加到场景树中
	# 假设游戏主场景是 /root/Main
	var main_scene = context.attacker.get_tree().get_root().get_node_or_null("Main")
	if main_scene:
		main_scene.add_child(instance)
	else:
		# 作为备用，添加到根节点，但这可能不是期望的行为
		context.attacker.get_tree().get_root().add_child(instance)

	print("Spawned scene " + scene.resource_path + " at " + str(instance.global_position))