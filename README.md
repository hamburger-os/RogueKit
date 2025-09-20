# RogueKit：用于Godot引擎的模块化Roguelike开发套件

<!-- 在这里放置一个展示核心功能的GIF动图 -->
![RogueKit Showcase](docs/assets/showcase.gif)

本文档是 **RogueKit** 的高级概述。**RogueKit** 是一个基于Godot 4.4.1引擎和GDScript语言的模块化、可重用Roguelike游戏库。其核心目标是抽象Roguelike游戏开发中的通用复杂性，提供一个稳固、数据驱动且易于扩展的基础框架，从而使开发者能够将精力集中在创造独特的游戏玩法、内容和体验上。

## ✨ 核心特性

*   **🧩 高度组合化**: 遵循“组合优于继承”原则。通过为实体（Entity）挂载不同的组件（Component）来动态构建复杂的行为，而非依赖僵硬的继承树。
*   **💾 数据驱动设计**: 游戏的核心内容（如角色属性、技能效果、敌人配置、关卡波次）都通过Godot的`Resource`（`.tres`文件）进行定义，使策划和设计师无需编写代码即可调整游戏平衡、添加新内容。
*   **⚔️ 游戏循环无关**: 框架底层分离了行动（Action）和游戏循环（Game Loop）的具体实现，使其可以同时支持**即时制**（如《吸血鬼幸存者》）和**回合制**（如传统Roguelike）游戏。
*   **🗺️ 可扩展的世界生成**: 提供了一套基于“生成通道”（Generation Pass）的地图构建系统。开发者可以通过组合内置的通道（如BSP树、元胞自动机）或编写自定义通道来创建风格各异的地图。
*   **🤖 灵活的AI框架**: 基于行为树（Behavior Tree）和数据驱动的AI配置文件`AIBehaviorProfile`，可以为不同类型的敌人配置截然不同的行为逻辑，并可在运行时动态切换。
*   **🔌清晰的扩展边界**: `RogueKit` 提供了一套稳固的基类。当需要实现独特的游戏机制时，您应该通过继承这些基类来扩展功能，而不是修改库的源代码，确保了项目的长期可维护性。

## 🚀 快速上手

### 1. 安装

`RogueKit` 推荐作为 **Git Submodule** 集成到您的Godot项目中。

```bash
# 在你的Godot项目根目录下执行
git submodule add [repository_url] lib/roguekit
git submodule update --init --recursive
```

### 2. 最小示例：生成一个随机地牢

1.  **创建场景**:
    *   创建一个新的Godot场景。
    *   添加一个 `Node2D` 作为根节点，并将其重命名为 `Dungeon`。
    *   为 `Dungeon` 节点附加一个新的脚本 `dungeon.gd`。
    *   添加一个 `TileMap` 节点用于渲染。

2.  **编写脚本 (`dungeon.gd`)**:

    ```gdscript
    extends Node2D

    # 引用RogueKit中的地图生成器和配置文件
    const MapGenerator = preload("res://lib/roguekit/world_gen/map_generator.gd")
    const MapGenerationProfile = preload("res://lib/roguekit/world_gen/map_generation_profile.gd")
    const BSPTreePass = preload("res://lib/roguekit/world_gen/bsp_tree_pass.gd")

    @onready var tile_map: TileMap = $TileMap

    func _ready() -> void:
        # 1. 创建一个地图生成配置 (Profile)
        var profile = MapGenerationProfile.new()
        profile.map_size = Vector2i(100, 60)
        
        # 2. 添加一个BSP树生成通道 (Pass)
        var bsp_pass = BSPTreePass.new()
        profile.generation_passes.append(bsp_pass)

        # 3. 生成地图数据
        var map_data = MapGenerator.generate(profile)

        # 4. 在TileMap上绘制地图
        # (你需要预先为TileMap设置好墙壁和地板的图块)
        for x in range(map_data.width):
            for y in range(map_data.height):
                if map_data.get_tile(x, y) == map_data.TileType.WALL:
                    # set_cell(layer, coords, source_id, atlas_coords)
                    tile_map.set_cell(0, Vector2i(x, y), 0, Vector2i(0, 0)) # 墙壁图块
                else:
                    tile_map.set_cell(0, Vector2i(x, y), 0, Vector2i(1, 0)) # 地板图块
    ```

3.  **运行场景**，您将看到一个由`RogueKit`生成的基础地牢！

## 📚 文档章节

为了提高可读性和可维护性，更详细的设计文档已被拆分为以下几个部分：

*   [1. 基础架构与核心原则](./docs/01_architecture_and_principles.md)
*   [2. 世界生成子系统](./docs/02_world_generation.md)
*   [3. 实体与属性子系统](./docs/03_entity_and_stats.md)
*   [4. 物品、库存与掉落子系统](./docs/04_items_and_inventory.md)
*   [5. 游戏状态与进程管理](./docs/05_game_state_and_progress.md)
*   [6. 行动与游戏循环系统](./docs/06_action_and_game_loop.md)
*   [7. AI行为框架](./docs/07_ai_framework.md)
*   [8. UI工具包与数据绑定](./docs/08_ui_toolkit.md)
*   [9. 输入处理与配置](./docs/09_input_handling.md)
*   [10. 视觉与音频反馈系统](./docs/10_feedback_systems.md)
*   [11. 扩展性指南](./docs/11_extensibility_guide.md)
*   [12. 质量保障：测试策略与调试工具](./docs/12_quality_assurance.md)
*   [13. 项目路线图与版本规划](./docs/13_roadmap.md)
*   [14. 贡献指南与社区规范](./docs/14_contribution_guide.md)
*   [15. 库的集成与初步使用](./docs/15_integration_guide.md)