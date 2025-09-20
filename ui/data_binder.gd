# 通用数据绑定节点
# 将一个数据源的属性变化绑定到一个目标UI控件的属性上。
#
# 使用方法:
# 1. 将此节点添加到场景中。
# 2. 在编辑器中设置 Source Node, Source Property, Target Node, Target Property。
# 3. 假设 Source Property 是 "health", DataBinder 会自动尝试连接到 "health_changed" 信号。
# 4. 当信号发出时，它会将新的值设置到 Target Node 的 Target Property 上。
class_name DataBinder
extends Node

@export var source_node: NodePath
@export var source_property: String
@export var target_node: NodePath
@export var target_property: String

var _source_node: Node
var _target_node: Node

func _ready():
	_source_node = get_node_or_null(source_node)
	_target_node = get_node_or_null(target_node)

	if not _source_node or not _target_node:
		push_warning("DataBinder: Source or Target node not found.")
		return

	if source_property.is_empty() or target_property.is_empty():
		push_warning("DataBinder: Source or Target property is not set.")
		return

	# 约定：信号名称是属性名称 + "_changed"
	var signal_name = source_property + "_changed"
	if not _source_node.has_signal(signal_name):
		push_warning("DataBinder: Source node does not have the expected signal '" + signal_name + "'.")
		return

	# 连接信号
	var signal_callable = Callable(_source_node, signal_name)
	signal_callable.connect(_on_source_data_changed)
	
	# 初始值设置
	_on_source_data_changed(_source_node.get(source_property))


# 当源数据变化时调用的通用处理函数
# 使用可变参数(...)来接收所有信号参数
func _on_source_data_changed(...args):
	if args.is_empty():
		return

	# 约定：我们总是使用信号的最后一个参数作为新的值
	var new_value = args[-1]

	if is_instance_valid(_target_node):
		_target_node.set(target_property, new_value)