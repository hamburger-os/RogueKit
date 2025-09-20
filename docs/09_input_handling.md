[&#8617; 返回总览](../README.md)

---

## 9. 输入处理与配置

一个健壮的输入系统需要能够处理多种设备，并允许玩家自定义按键。

### 9.1. 抽象输入：`Input Map`

所有输入处理都必须通过Godot的`Input Map`进行。库提供的`PlayerInputComponent`将监听抽象的动作名称（如`move_forward`, `use_item`），而不是硬编码的物理按键（如`W`键）。这使得玩家可以在游戏设置中轻松地重新映射按键。

### 9.2. 输入上下文管理

在游戏的不同状态下，相同的按键可能有不同的功能（例如，在游戏中移动，在菜单中导航）。为了管理这种复杂性，我们将设计一个`InputContextManager`。
* **定义上下文**: 开发者可以定义不同的输入上下文，如`GameplayContext`, `MenuContext`, `InventoryContext`。
* **切换上下文**: `GameManager`将负责在不同游戏状态之间切换时，激活或禁用相应的输入上下文。例如，当打开库存界面时，`GameplayContext`将被禁用，而`InventoryContext`将被激活。这确保了玩家在查看物品时不会意外地移动角色。