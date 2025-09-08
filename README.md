# 源力法师：突围 (Aethermancer: Breakout)

## 1. 项目定位与设计哲学

### 1.1. 项目愿景

欢迎来到 `RogueKit` 框架的旗舰开发蓝图：**“源力法师：突围”**。

本项目的首要目标是放弃宽泛的功能陈列，转而提供一个**高密度、可执行的开发指南**。我们将以构建一个具体、可玩、融合了现代 Roguelite 精华的游戏为目标，展示 `RogueKit` 框架的全部潜力。

“源力法师：突围”的游戏设计融合了以下核心要素：

1.  **高强度竞技场生存**：玩家在有限空间内面对持续生成的、数量庞大的敌人波次。生存的重点在于实时走位、资源管理和宏观策略选择。
2.  **深度能力构筑**：这是游戏的核心乐趣来源。玩家的成长系统超越了简单的线性升级。玩家通过收集**法术核心（Cores）和修饰符（Modifiers）**，并将它们自由组合，从而动态地设计和进化自己的攻击手段。

### 1.2. 核心设计哲学

本项目严格遵循 `RogueKit` 库的核心设计哲学，这些哲学是实现高效开发和复杂系统的基石：

  * **组合优于继承 (Composition over Inheritance)**：游戏实体（如玩家和敌人）是通过“组装”功能组件（如 `HealthComponent`、`StatsComponent`、`AbilityManagerComponent`）来构建的，而不是通过创建复杂的继承树。这为动态添加或移除能力提供了极高的灵活性。
  * **数据驱动设计 (Data-Driven Design)**：游戏的大部分内容——包括角色属性、物品效果、敌人配置、法术组件和关卡波次——都是通过 Godot 的 `Resource`（资源文件，`.tres`）来定义的，而非硬编码在脚本中。这使得游戏设计师可以不接触代码就能调整游戏平衡和添加新内容。
  * **清晰的扩展边界 (Clear Extension Boundaries)**：`RogueKit` 提供了一套稳固的基础类。当需要实现独特的游戏机制时（例如一个全新的法术修饰符逻辑），您应该通过继承这些基础类来扩展功能，而不是修改库的源代码。

## 2. 框架特性应用展示

本蓝图将重点展示如何应用 `RogueKit` 框架来实现以下高度融合的系统：

  * **动态能力构筑系统**：演示 `RogueKit` 的效果引擎如何将能力分解为\*\*“核心组件”**（如 `ProjectileCore` - 发射投射物）和**“修饰组件”\*\*（如 `MultishotModifier` - 增加发射数量，`ChainReactionModifier` - 赋予连锁反应能力）。玩家在运行时可以将修饰符动态附加到核心上。
  * **竞技场生存循环**：演示如何配置 `GameManager` 和 `WaveSpawner` 来驱动实时游戏循环，管理基于时间的敌人生成波次和玩家的自动攻击触发机制。
  * **涌现式协同引擎 (Emergent Synergy Engine)**：展示如何利用框架的全局属性系统（`StatsComponent`）和效果堆叠机制（`EffectData`），实现不同升级选项之间的乘法效应，而无需为每种协同组合编写特定代码。
  * **数据驱动的 AI**：使用 `AIBehaviorProfile` 资源，为不同类型的敌人（如近战集群单位、远程狙击单位、特殊辅助单位）配置截然不同的行为逻辑。

## 3. 安装与环境设置

**依赖项**：Godot Engine (版本与 `RogueKit` 库兼容)

### 3.1. Git Submodule 安装

本项目使用 Git Submodule 来管理 `RogueKit` 库的依赖。

1.  **克隆仓库（推荐方式）**：
    使用 `--recurse-submodules` 标志来确保在克隆主项目的同时自动初始化并拉取 `RogueKit` 子模块。

    ```bash
    git clone --recurse-submodules [repository_url]
    ```

2.  **针对已克隆的项目**：
    如果项目已经克隆，但 `lib/roguekit` 目录为空，请运行以下命令来初始化并拉取子模块：

    ```bash
    git submodule update --init --recursive
    ```

### 3.2. Godot 引擎设置

1.  **导入项目**：打开 Godot 引擎，使用项目管理器的“导入”功能，选择本项目的 `project.godot` 文件。
2.  **检查 Autoloads**：为确保 `RogueKit` 的核心系统（如 `GameManager`、`EffectEngine`、`SignalBus`）能够正常工作，请检查 `项目 -> 项目设置 -> Autoload`。本示例应已预先配置好所有必需的全局单例。

## 4. 核心工作流：构筑“源力法师”的玩法机制

本节是开发指南的核心。我们将摒弃泛用示例，转而详细演示如何使用 `RogueKit` 的数据驱动方法论来实现“源力法师”的具体游戏机制。

### 4.1. 工作流一：实现动态能力构筑系统

**目标**：构建游戏的核心乐趣循环——允许玩家将“连锁闪电”修饰符添加到现在发射的“火焰弹”上，使其变为“连锁火焰弹”。

#### 步骤 1：定义能力的核心（Core）和修饰符（Modifier）的数据结构

首先，我们需要定义两种类型的能力资源：

  * **`AbilityCoreData` (Resource)**：定义法术的基础行为。例如 `core_fireball.tres`。

      * `core_type`: `PROJECTILE` (投射物类型)
      * `base_damage`: 10
      * `base_speed`: 300
      * `vfx_scene`: `res://prefabs/vfx/fireball.tscn`
      * `hit_effects`: [ `DamageEffect.tres` ]

  * **`AbilityModifierData` (Resource)**：定义一个可附加的额外逻辑。例如 `modifier_chain_reaction.tres`。

      * `modifier_name`: "连锁反应"
      * `description`: "击中敌人时弹射到附近的额外2个目标。"
      * `tags_required`: [ `projectile` ] (确保只能附加到投射物核心上)
      * `effects_to_add`: [ `ChainReactionEffect.tres` ]

#### 步骤 2：实现修饰符的独特逻辑 (`EffectData` 扩展)

“连锁反应”需要自定义逻辑，因此我们创建新脚本：

  * **创建脚本 `effect_chain_reaction.gd`**，继承自 `EffectData`。
  * **重写 `execute(context)` 方法**：
      * `context` 对象包含触发此效果所需的所有信息（如攻击者、被击中的目标、伤害量）。
      * 在 `execute` 方法中，编写逻辑：
        1.  获取被击中目标的位置 `target.global_position`。
        2.  在一定半径内搜索除 `target` 外的其他敌人。
        3.  选取最近的N个敌人（例如2个）。
        4.  对这N个敌人应用一个新的、伤害略微衰减的 `DamageEffect` 实例。

#### 步骤 3：运行时组装

1.  玩家的 `AbilityManagerComponent` 持有一个 `AbilityCoreData` 实例。
2.  当玩家在升级时选择了 `modifier_chain_reaction.tres`，系统执行以下操作：
3.  获取 `modifier_chain_reaction.tres` 中的 `effects_to_add_on_hit` 数组（即 `ChainReactionEffect.tres`）。
4.  将 `ChainReactionEffect.tres` 添加到玩家当前 `AbilityCoreData` 实例的 `hit_effects` 数组中。
5.  **完成**：从下一次攻击开始，当基础的 `DamageEffect` 执行完毕后，框架会自动遍历并执行新添加的 `ChainReactionEffect`，实现了能力的动态扩展，而无需编写任何 `if/else` 耦合代码。

### 4.2. 工作流二：实现涌现式属性协同

**目标**：展示框架如何自动处理不同来源的属性加成，实现乘法效应，而无需为每种协同编写特定代码。

**场景**：玩家有两个独立的升级选项：“多重射击”（增加投射物数量）和“法术专注”（增加伤害和范围）。

#### 步骤 1：配置升级项的数据

  * **升级A (`upgrade_multishot.tres`)**:

      * 效果：包含一个 `StatModifier` 资源，其逻辑为 `ADDITIVE`（加法），目标属性 `projectile_count`，值 `+2`。

  * **升级B (`upgrade_focus.tres`)**:

      * 效果1：包含一个 `StatModifier` 资源，其逻辑为 `MULTIPLICATIVE`（乘法），目标属性 `damage_multiplier`，值 `+0.2` (即+20%)。
      * 效果2：包含一个 `StatModifier` 资源，其逻辑为 `MULTIPLICATIVE`（乘法），目标属性 `area_size_multiplier`，值 `+0.2` (即+20%)。

#### 步骤 2：能力脚本读取属性

能力的核心脚本（例如 `core_fireball.gd` 的执行逻辑）在触发时不使用固定数值，而是向 `StatsComponent` 请求计算后的属性值：

```gdscript
# 伪代码：在法术执行时
var projectile_count = stats_component.get_stat_value("projectile_count")
var damage_amount = base_damage * stats_component.get_stat_value("damage_multiplier")
var area_size = base_area_size * stats_component.get_stat_value("area_size_multiplier")

for i in range(projectile_count):
    # ... 发射投射物，并赋予其计算后的伤害和范围 ...
```

#### 步骤 3：涌现式协同

当玩家同时拥有升级A和升级B时：

  * `StatsComponent` 自动计算 `projectile_count` 为 `1 (基础) + 2 = 3`。
  * `StatsComponent` 自动计算 `damage_multiplier` 为 `1.0 * 1.2 = 1.2`。
  * 能力脚本读取这些新值，自动发射3个伤害和范围均提升20%的投射物。
  * **结论**：通过将**状态管理**（`StatsComponent`）与**逻辑执行**分离，实现了不同升级间的自动协同，极大地提高了开发效率和玩法的丰富度。

### 4.3. 工作流三：配置竞技场波次生成器

**目标**：配置一个动态的、随时间增加难度的敌人生成流程。

#### 步骤 1：设计波次配置文件 (`WaveProfileData`)

创建一个继承自 `Resource` 的新数据类型 `WaveProfileData.tres`，用于存储关卡的时间线。

```gdscript
# WaveProfileData.tres 内部数据结构示例
var timeline_events = [
    { "timestamp": 0, "action": "start_spawning", "enemy_type": "grunt", "spawn_rate": 2.0, "max_alive": 20 },
    { "timestamp": 30, "action": "start_spawning", "enemy_type": "ranger", "spawn_rate": 0.5, "max_alive": 5 },
    { "timestamp": 60, "action": "modify_spawn_rate", "enemy_type": "grunt", "new_rate": 3.0 },
    { "timestamp": 120, "action": "spawn_elite_wave", "elite_group_id": "group_a", "count": 3 },
    { "timestamp": 180, "action": "set_boss_flag" }
]
```

#### 步骤 2：实现波次管理器 (`WaveManager`)

  * 创建一个 `WaveManager` 节点。
  * 在游戏开始时加载对应的 `WaveProfileData.tres`。
  * 在 `_process` 函数中，根据游戏内的计时器 `game_time` 遍历 `timeline_events` 数组。
  * 当 `game_time` 达到事件的 `timestamp` 时，执行相应的 `action`，调用 `Spawner` 节点来生成敌人或调整生成参数。

## 5. 高级扩展模式：超越基础配置

当标准组件无法满足特定需求时，您可以通过继承 `RogueKit` 的基类来创建自定义逻辑。这是推荐的扩展方式，因为它不会破坏库的封装性。

### 5.1. 模式一：创建自定义游戏效果

**场景**：您需要一个“吸血”效果，在造成伤害时按比例回复攻击者的生命值。内置的 `StatModifier` 无法处理这种情景交互。

**工作流**：

1.  **创建新脚本**：创建一个新脚本文件（例如 `effect_lifesteal.gd`），使其继承自 `RogueKit` 的 `EffectData` 基类。
2.  **实现逻辑**：重写 `execute(context)` 方法。在此方法中，编写逻辑：
      * 从 `context` 中获取造成伤害的数值 `damage_dealt`。
      * 从 `context.attacker` 的 `StatsComponent` 中获取吸血率 `lifesteal_ratio`。
      * 计算回复量 `heal_amount = damage_dealt * lifesteal_ratio`。
      * 调用 `context.attacker.health_component.heal(heal_amount)`。
3.  **配置使用**：在 Godot 编辑器中创建该新脚本的资源实例（`.tres` 文件）。现在，您可以将这个“吸血效果”资源添加到物品或升级选项的 `effects` 数组中。

### 5.2. 模式二：设计自定义地图生成通道

**场景**：您需要一个特殊的生成通道来在地图上放置河流，`RogueKit` 没有提供此算法。

**工作流**：

1.  **创建新脚本**：创建一个新脚本文件（例如 `river_generation_pass.gd`），使其继承自 `GenerationPass` 基类。
2.  **实现逻辑**：重写 `generate(map_data)` 方法。在此方法中，实现您的河流生成算法（例如使用随机游走算法），修改传入的 `MapData` 对象，将对应坐标的瓦片类型设置为 `FLOOR`。
3.  **配置使用**：创建该脚本的资源实例后，将其拖拽到 `MapGenerationProfile` 的通道数组中，与其他生成通道（如 `BSPTreePass`）组合使用。

### 5.3. 模式三：扩展 AI 行为树节点

**场景**：AI 需要一个新的决策条件：“检查 3 格范围内是否有盟友”。

**工作流**：

1.  **创建新脚本**：创建一个新脚本文件（例如 `condition_check_nearby_allies.gd`），使其继承自 `BehaviorNode` 基类。
2.  **实现逻辑**：重写 `tick()` 方法。编写逻辑来扫描周围区域，检查是否存在其他“盟友”标签的实体。根据检查结果返回 `Status.SUCCESS` 或 `Status.FAILURE`。
3.  **配置使用**：在 Godot 编辑器中，这个新创建的条件节点现在可以作为构建块，在 `AIBehaviorProfile` 中与其他节点一起组装，以创建更复杂的 AI 逻辑。

## 6. 推荐的项目结构

为了保持清晰和可维护性，建议采用以下目录结构来分离库代码、项目内容和自定义扩展：

```plaintext
godot-project-root/
│
├── lib/
│   └── roguekit/               # RogueKit 库 (Git Submodule)，不应修改内部文件。
│
├── content/                    # 游戏内容配置层 (主要存放 .tres 资源)
│   ├── characters/             # 玩家角色数据 (CharacterData)
│   │
│   ├── abilities/              # 能力构筑相关
│   │   ├── cores/              # 法术核心 (AbilityCoreData)
│   │   └── modifiers/          # 法术修饰符 (AbilityModifierData)
│   │
│   ├── upgrades/               # 升级池中的升级选项 (UpgradeData)
│   │
│   ├── enemies/                # 敌人数据 (EntityData) 和 AI 配置 (AIBehaviorProfile)
│   │
│   ├── items/                  # 局内外的物品数据 (ItemData)
│   │
│   └── levels/                 # 关卡配置
│       ├── wave_profiles/      # 竞技场波次配置文件 (WaveProfileData)
│       └── loot_tables/        # 掉落表 (LootTable)
│
├── prefabs/                    # 游戏场景预制件 (主要存放 .tscn 文件)
│   ├── entities/               # 玩家和敌人的场景文件
│   ├── abilities_vfx/          # 技能投射物、VFX等场景
│   └── ui/                     # UI界面和组件场景
│
├── extensions/                 # 自定义逻辑层 (主要存放 .gd 脚本)
│   ├── custom_effects/         # 继承自 EffectData 的脚本 (如 effect_lifesteal.gd)
│   ├── custom_ai_nodes/        # 继承自 BehaviorNode 的脚本
│   └── custom_components/      # 项目特定的新组件 (如 AbilityManagerComponent)
│
├── systems/                    # 项目特定的管理器脚本 (例如 WaveManager, UpgradeManager)
└── project.godot
```