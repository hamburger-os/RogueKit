# 一个简单的调试覆盖层，用于显示场景中所有实体的关键信息。
class_name DebugDisplay
extends CanvasLayer

@onready var label: Label = $MarginContainer/Label

var tracked_entities: Array[Node] = []

func _ready():
	# 连接到 GameManager 的信号来动态追踪实体
	GameManager.entity_registered.connect(_on_entity_registered)
	GameManager.entity_removed_from_grid.connect(_on_entity_removed)
	
	# 可能有一些实体在 DebugDisplay ready 之前就已经注册了，
	# 所以这里可以考虑从 GameManager 获取一个当前的实体列表（如果 GameManager 提供的话）。
	# 为了简化，我们假设 DebugDisplay 是最早准备好的节点之一。


func _on_entity_registered(entity: Node):
	if not tracked_entities.has(entity):
		tracked_entities.append(entity)


func _on_entity_removed(entity: Node):
	if tracked_entities.has(entity):
		tracked_entities.erase(entity)


func _process(_delta: float):
	if not is_instance_valid(label):
		return
		
	var debug_text = ""
	for entity in tracked_entities:
		if not is_instance_valid(entity):
			continue
		
		var health_text = "N/A"
		if entity.health_component:
			health_text = "%d/%d" % [entity.health_component.current_health, entity.health_component.max_health]
			
		var speed_text = "N/A"
		if entity.stats_component:
			speed_text = str(entity.get_speed())
			
		debug_text += "%s | HP: %s | Speed: %s\n" % [entity.name, health_text, speed_text]
		
	label.text = debug_text
