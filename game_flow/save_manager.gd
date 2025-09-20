# 存档管理器 (Autoload Singleton)
# 负责持久化元进度数据 (Meta-progression)，如已解锁的角色、全局货币等。
class_name SaveManager
extends Node

# 保存文件的路径
const SAVE_PATH = "user://roguekit_save.tres"

# 在内存中持有的元进度数据
var meta_data: MetaProgressionData


func _ready():
	load_game()


# 加载游戏。如果存档文件不存在，则创建一个新的默认存档。
func load_game():
	if FileAccess.file_exists(SAVE_PATH):
		var loaded_data = ResourceLoader.load(SAVE_PATH)
		if loaded_data is MetaProgressionData:
			meta_data = loaded_data
			print("Save game loaded successfully.")
		else:
			push_error("Failed to load save game: file is corrupted or of wrong type.")
			_create_new_save()
	else:
		print("No save file found. Creating a new one.")
		_create_new_save()


# 保存当前的元进度数据到文件
func save_game():
	if not meta_data:
		push_error("No meta data to save.")
		return

	var error = ResourceSaver.save(meta_data, SAVE_PATH)
	if error == OK:
		print("Game saved successfully to " + SAVE_PATH)
	else:
		push_error("Failed to save game. Error code: " + str(error))


# 创建一个新的、默认的存档数据
func _create_new_save():
	meta_data = MetaProgressionData.new()
	# 可以在这里设置一些初始值，如果需要的话
	# meta_data.unlocked_characters.append("starter_mage")
	save_game()