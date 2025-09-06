# 游戏流程管理器 (Autoload Singleton)
# 基于有限状态机 (FSM) 控制游戏的整体流程，如主菜单、游戏中、游戏结束等。
extends Node

# 游戏状态枚举
enum GameState {MAIN_MENU, GAME_IN_PROGRESS, GAME_OVER}

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


# 外部调用的方法来改变状态
func start_new_game():
	self.current_state = GameState.GAME_IN_PROGRESS

func end_game():
	self.current_state = GameState.GAME_OVER