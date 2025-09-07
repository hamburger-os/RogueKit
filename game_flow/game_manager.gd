# 游戏流程管理器 (Autoload Singleton)
# 基于有限状态机 (FSM) 控制游戏的整体流程，如主菜单、游戏中、游戏结束等。
extends Node

# 游戏状态枚举
enum GameState {MAIN_MENU, GAME_IN_PROGRESS, GAME_OVER}

# --- 场景节点依赖 (需要_ready) ---
@onready var turn_manager: TurnManager = get_node_or_null("TurnManager")
@onready var map_generator: MapGenerator = get_node_or_null("MapGenerator")
@onready var spawner: Spawner = get_node_or_null("Spawner")
@onready var entity_container: Node = get_node_or_null("EntityContainer") # 用于存放所有实体的节点
@onready var map_builder: MapBuilder = get_node_or_null("MapBuilder")
@onready var tilemap_node: TileMap = get_node_or_null("TileMap") # 目标渲染的TileMap节点

# --- 配置资源 (在编辑器中设置) ---
@export var map_profile: MapGenerationProfile
@export var spawn_profile: SpawnProfile

# --- 游戏世界数据 ---
# 当前激活的地图数据资源引用
var current_map_data: MapData
# 游戏中使用的瓦片大小（像素）。
const TILE_SIZE = 64 # TODO: 未来应从 TileSet 资源动态获取或配置

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


func _on_state_changed(state: GameState):
	match state:
		GameState.MAIN_MENU:
			print("Game State: Main Menu")
			# 在这里可以加载主菜单场景
		GameState.GAME_IN_PROGRESS:
			print("Game State: Game In Progress")
			# 在这里可以启动游戏主循环
		GameState.GAME_OVER:
			print("Game State: Game Over")
			# 在这里可以显示游戏结束画面


# --- 公共接口方法 ---

# 设置当前激活的地图数据
func set_current_map(map_data: MapData):
	self.current_map_data = map_data

# --- 实体查询接口 ---
func register_entity_at(entity: Node, position: Vector2i):
	entity_grid[position] = entity
	# 假设第一个注册的实体是玩家
	if player_entity == null and entity.has_node("PlayerInputComponent"):
		player_entity = entity

func update_entity_position(entity: Node, old_position: Vector2i, new_position: Vector2i):
	if entity_grid.get(old_position) == entity:
		entity_grid.erase(old_position)
	entity_grid[new_position] = entity

func get_entity_at(position: Vector2i) -> Node:
	return entity_grid.get(position, null)

func remove_entity_at(position: Vector2i):
	if entity_grid.has(position):
		entity_grid.erase(position)

func get_grid_position(entity: Node) -> Vector2i:
	if TILE_SIZE == 0:
		push_error("TILE_SIZE in GameManager is zero, cannot calculate grid position.")
		return Vector2i.ZERO
	return Vector2i(
		roundi(entity.global_position.x / TILE_SIZE),
		roundi(entity.global_position.y / TILE_SIZE)
	)

# 外部调用的方法来改变状态
func start_new_game():
	# TODO: 清理上一局游戏的状态和实体

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
		push_warning("MapBuilder or TileMap node not configured in GameManager scene.")

	# 2. 生成实体
	if not spawner or not spawn_profile or not entity_container:
		push_error("Spawner, SpawnProfile, or EntityContainer not configured in GameManager.")
		return
	
	var spawned_actors = spawner.spawn_entities(current_map_data, spawn_profile, entity_container, TILE_SIZE)
	
	# 3. 注册实体到回合管理器并启动游戏循环
	if not turn_manager:
		push_error("TurnManager not found in GameManager scene tree.")
		return
		
	for actor in spawned_actors:
		turn_manager.register_actor(actor)
		# 注册实体位置
		var grid_pos = Vector2i(roundi(actor.global_position.x / TILE_SIZE), roundi(actor.global_position.y / TILE_SIZE))
		register_entity_at(actor, grid_pos)
	
	if not spawned_actors.is_empty():
		turn_manager.start_game()
	else:
		push_warning("No actors were spawned.")

	self.current_state = GameState.GAME_IN_PROGRESS

func end_game():
	self.current_state = GameState.GAME_OVER