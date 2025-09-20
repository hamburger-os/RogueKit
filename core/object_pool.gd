# 对象池 (Autoload Singleton)
# 负责预实例化和复用常用的场景，如敌人、射弹和视觉效果，以避免频繁的实例化和销毁开销。
extends Node

# 使用字典来管理不同类型的对象池
# Key: PackedScene (场景资源), Value: Array (对象实例队列)
var _pools: Dictionary = {}

# 当一个对象被创建时，用元数据记录它的来源场景
const SCENE_SOURCE_META = "__scene_source"


# 从对象池获取一个对象实例。
# Spawner 或其他系统在获取实例后，应负责将其添加到场景树并设置其位置。
func get_instance(scene: PackedScene) -> Node:
	if not scene:
		push_error("ObjectPool: Cannot get instance from a null scene.")
		return null

	if not _pools.has(scene) or _pools[scene].is_empty():
		# 如果池子为空或不存在，创建一个新实例
		var new_instance = scene.instantiate()
		new_instance.set_meta(SCENE_SOURCE_META, scene)
		return new_instance
	else:
		# 从池中获取一个现有实例
		var instance = _pools[scene].pop_front()
		
		# 在返回之前，确保它被正确重置
		if instance.has_method("reset_state"):
			instance.reset_state()
			
		# 重新启用通用功能。具体的游戏逻辑应在 reset_state 中处理。
		instance.visible = true
		instance.set_process(true)
		instance.set_physics_process(true)
		
		return instance


# 将一个对象实例返回到对象池
func return_instance(instance: Node):
	if not is_instance_valid(instance):
		return

	var source_scene = instance.get_meta(SCENE_SOURCE_META, null)
	if source_scene == null:
		push_warning("ObjectPool: Trying to return an object that was not from the pool. It will be freed instead.")
		instance.queue_free()
		return

	# 确保对象在被归还时从当前父节点移除
	if instance.get_parent():
		instance.get_parent().remove_child(instance)

	# 禁用对象以节省性能
	instance.visible = false
	instance.set_process(false)
	instance.set_physics_process(false)
	
	if not _pools.has(source_scene):
		_pools[source_scene] = []
		
	_pools[source_scene].append(instance)


# 预先填充对象池，以便在需要时快速获取。
func prepopulate_pool(scene: PackedScene, count: int):
	if not scene:
		push_error("ObjectPool: Cannot prepopulate pool with a null scene.")
		return

	if not _pools.has(scene):
		_pools[scene] = []
	
	for i in range(count):
		var instance = scene.instantiate()
		instance.set_meta(SCENE_SOURCE_META, scene)
		
		# 禁用并添加到池中
		instance.visible = false
		instance.set_process(false)
		instance.set_physics_process(false)
		
		_pools[scene].append(instance)