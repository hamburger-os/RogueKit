# 敌人生成器
# 负责根据配置实例化敌人。
class_name Spawner
extends Node

@export var enemy_scene: PackedScene # 要生成的敌人场景
@export var spawn_rate: float = 1.0 # 每秒生成数量
@export var max_alive: int = 5 # 允许存在的最大敌人数量
@export var spawn_points: Array[Node2D] # 敌人可以生成的地点

var _time_since_last_spawn: float = 0.0
var _active_enemies: Array[Node] = []

func _process(delta: float):
	# 移除已释放的敌人
	_active_enemies = _active_enemies.filter(func(enemy): return is_instance_valid(enemy))

	if _active_enemies.size() < max_alive:
		_time_since_last_spawn += delta
		if _time_since_last_spawn >= 1.0 / spawn_rate:
			_spawn_enemy()
			_time_since_last_spawn = 0.0

func _spawn_enemy():
	if not enemy_scene:
		push_warning("Spawner: enemy_scene is not assigned.")
		return
	if spawn_points.is_empty():
		push_warning("Spawner: No spawn_points assigned.")
		return

	var enemy = enemy_scene.instantiate()
	get_tree().root.add_child(enemy)

	var random_spawn_point = spawn_points[randi() % spawn_points.size()]
	enemy.global_position = random_spawn_point.global_position
	
	_active_enemies.append(enemy)

func is_finished() -> bool:
	# 如果没有设置最大存活敌人数量，则 Spawner 永远不会“完成”
	if max_alive <= 0:
		return false
	
	# 如果当前存活敌人数量达到最大值，并且没有新的敌人正在生成
	return _active_enemies.size() >= max_alive and spawn_rate <= 0.0
