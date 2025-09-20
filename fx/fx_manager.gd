# 效果管理器 (Autoload Singleton)
# 作为所有临时性视觉效果 (VFX) 和音效 (SFX) 的播放中心。
class_name FXManager
extends Node

# 将事件名称映射到 FXProfile 资源
# 在编辑器中进行配置
# 例如: {"entity_took_damage": load("res://.../fx/damage_fx.tres")}
@export var fx_profiles: Dictionary = {}

# 用于播放一次性音效的 AudioStreamPlayer 池
var _sfx_players: Array[AudioStreamPlayer] = []
const MAX_SFX_PLAYERS = 10 # 同时播放的最大音效数量

func _ready():
	# 连接到感兴趣的全局事件
	Events.entity_took_damage.connect(_on_entity_took_damage)
	Events.entity_died.connect(_on_entity_died)
	
	# 预先创建 SFX播放器池
	for i in range(MAX_SFX_PLAYERS):
		var player = AudioStreamPlayer.new()
		add_child(player)
		_sfx_players.append(player)


func _on_entity_took_damage(entity: Node, _amount: int, _source: Node):
	_play_fx_for_event("entity_took_damage", entity.global_position)


func _on_entity_died(entity: Node):
	_play_fx_for_event("entity_died", entity.global_position)


# 通用的效果播放函数
func _play_fx_for_event(event_name: String, position: Vector2):
	if not fx_profiles.has(event_name):
		return

	var profile: FXProfile = fx_profiles[event_name]
	if not profile:
		return

	# 播放 VFX
	if profile.vfx_scene:
		var vfx_instance = profile.vfx_scene.instantiate()
		# 假设VFX场景的根节点是Node2D或类似节点
		if vfx_instance is Node2D:
			vfx_instance.global_position = position
		# 将VFX实例添加到主场景树中
		get_tree().root.add_child(vfx_instance)
		# 假设VFX场景会自动销毁 (例如，使用 AnimationPlayer 的 "method" track 调用 queue_free)

	# 播放 SFX
	if profile.sfx_stream:
		_play_sfx(profile.sfx_stream)
		
	# TODO: 实现屏幕震动
	# if profile.shake_strength > 0 and profile.shake_duration > 0:
	# 	_start_screen_shake(profile.shake_strength, profile.shake_duration)


func _play_sfx(stream: AudioStream):
	for player in _sfx_players:
		if not player.is_playing():
			player.stream = stream
			player.play()
			return
	push_warning("FXManager: No available AudioStreamPlayer to play SFX.")