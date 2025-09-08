# 游戏流程管理器 (Autoload Singleton)
# 基于有限状态机 (FSM) 控制游戏的整体流程，如主菜单、游戏中、游戏结束等。
extends Node

# 游戏状态枚举
enum GameState {MAIN_MENU, GAME_IN_PROGRESS, GAME_OVER}

# --- 核心管理器依赖 (通过 @export 在编辑器中设置) ---
@export_group("Node Dependencies")
@export var turn_manager: TurnManager
@export var map_generator: MapGenerator
@export var spawner: Spawner
@export var map_builder: MapBuilder
@export var entity_container: Node # 用于存放所有实体的节点
@export var tilemap_node: TileMap   # 目标渲染的TileMap节点

# --- 配置资源 (在编辑器中设置) ---
@export_group("Data Profiles")
@export var map_profile: MapGenerationProfile
@export var spawn_profile: SpawnProfile

# --- 依赖注入的全局单例 ---
var events_bus: Node
var object_pool: ObjectPool

# --- 游戏世界数据 ---
# 当前激活的地图数据资源引用
var current_map_data: MapData
# 游戏中使用的瓦片大小（像素）。
var tile_size: Vector2i = Vector2i.ONE * 64

# --- 实体跟踪 ---
var player_entity: Node # 对玩家实体的引用，方便AI查找目标
var entity_grid: Dictionary = {} # 存储实体位置, key: Vector2i, value: Entity Node

# --- 状态管理 ---
# 当前游戏状态
var current_state: GameState = GameState.MAIN_MENU:
	set(new_state):
		if current_state != new_state:
			current_state = new_state
			_on_state_changed(new_state)


# 依赖注入的 setter
func set_dependencies(p_events_bus: Node, p_object_pool: ObjectPool):
	self.events_bus = p_events_bus
	self.object_pool = p_object_pool
	
	# 连接全局事件
	if events_bus:
		events_bus.entity_died.connect(_on_entity_died)


func _on_state_changed(state: GameState):
	match state:
		GameState.MAIN_MENU:
			print("Game State: Main Menu")
			# 在这里可以加载主菜单场景
		GameState.GAME_IN_PROGRESS:
			print("Game State: Game In Progress")
			# 启动游戏主循环
			if turn_manager:
				turn_manager.start_game()
		GameState.GAME_OVER:
			print("Game State: Game Over")
			# 在这里可以显示游戏结束画面
			if turn_manager:
				turn_manager.stop_game()


# --- 实体查询接口 ---
func register_entity_at(entity: Node, position: Vector2i):
	entity_grid[position] = entity
	# 通过检查组件来确定玩家实体，这比依赖顺序更可靠
	if player_entity == null and entity.find_child("PlayerInputComponent", true, false):
		player_entity = entity

func update_entity_position(entity: Node, old_position: Vector2i, new_position: Vector2i):
	if entity_grid.get(old_position) == entity:
		entity_grid.erase(old_position)
	entity_grid[new_position] = entity

func get_entity_at(position: Vector2i) -> Node:
	return entity_grid.get(position, null)

func remove_entity_from_grid(entity: Node):
	var grid_pos = get_grid_position(entity)
	if entity_grid.get(grid_pos) == entity:
		entity_grid.erase(grid_pos)
		
func get_grid_position(entity: Node) -> Vector2i:
	if tile_size.x == 0 or tile_size.y == 0:
		push_error("tile_size in GameManager has a zero component, cannot calculate grid position.")
		return Vector2i.ZERO
	return Vector2i(
		roundi(entity.global_position.x / tile_size.x),
		roundi(entity.global_position.y / tile_size.y)
	)

# --- 游戏流程控制 ---

# 外部调用的方法来改变状态
func start_new_game():
	_cleanup_previous_run()

	# 动态获取 TileSize
	if tilemap_node and tilemap_node.tile_set:
		self.tile_size = tilemap_node.tile_set.tile_size
	else:
		push_warning("TileMap or TileSet not found, using default tile_size: %s" % str(tile_size))

	# 1. 生成地图数据
	if not map_generator or not map_profile:
		push_error("MapGenerator or MapProfile not configured in GameManager.")
		return
	var seed = randi() # 使用随机种子
	self.current_map_data = map_generator.generate_map(80, 45, map_profile, seed) # 示例尺寸

	# 1b. 渲染视觉地图
	if map_builder and tilemap_node:
		map_builder.build_map(current_map_data, tilemap_node)
	else:
		push_warning("MapBuilder or TileMap node not configured in GameManager.")

	# 2. 生成实体
	if not spawner or not spawn_profile or not entity_container:
		push_error("Spawner, SpawnProfile, or EntityContainer not configured in GameManager.")
		return
	
	var spawned_actors = spawner.spawn_entities(current_map_data, spawn_profile, entity_container, tile_size)
	
	# 3. 注册实体到回合管理器
	if not turn_manager:
		push_error("TurnManager not configured in GameManager.")
		return
		
	for actor in spawned_actors:
		# 注入依赖
		if actor.has_method("set_dependencies"):
			actor.set_dependencies(events_bus, object_pool)
		
		turn_manager.register_actor(actor)
		var grid_pos = get_grid_position(actor)
		register_entity_at(actor, grid_pos)

	self.current_state = GameState.GAME_IN_PROGRESS

func end_game():
	self.current_state = GameState.GAME_OVER

# --- 私有方法 ---

func _cleanup_previous_run():
	# 1. 清空回合管理器
	if turn_manager:
		turn_manager.clear_actors()

	# 2. 清空实体网格和玩家引用
	entity_grid.clear()
	player_entity = null

	# 3. 从场景中移除并返还所有实体到对象池
	if entity_container and object_pool:
		for entity in entity_container.get_children():
			object_pool.return_instance(entity) # return_instance 会自动处理 remove_child
	elif entity_container:
		# 如果没有对象池，则直接销毁
		for entity in entity_container.get_children():
			entity.queue_free()

	# 4. 清空 TileMap
	if tilemap_node:
		tilemap_node.clear()

func _on_entity_died(entity: Node):
	# 从实体网格中移除，防止AI或其他系统仍然尝试与已死亡的实体交互
	remove_entity_from_grid(entity)
	
	if entity == player_entity:
		end_game()