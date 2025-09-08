# 一个简单的调试覆盖层，用于显示场景中所有实体的关键信息。
class_name DebugDisplay
extends CanvasLayer

@onready var label: Label = $MarginContainer/Label

var tracked_entities: Array[Node] = []

func _ready():
	# 使用一个组来查找所有实体
	tracked_entities = get_tree().get_nodes_in_group("entities")
	
	# 如果没有实体在组里，尝试通过类型查找
	if tracked_entities.is_empty():
		_find_entities_by_type(get_tree().root)

func _find_entities_by_type(node: Node):
	if node is Entity and not node.is_in_group("entities"):
		tracked_entities.append(node)
	
	for child in node.get_children():
		_find_entities_by_type(child)


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
