# 效果配置
# 这个资源用于将一个事件与一个或多个视觉/音频效果关联起来。
class_name FXProfile
extends Resource

# 要实例化的视觉效果场景 (例如粒子效果或动画)
@export var vfx_scene: PackedScene

# 要播放的音效
@export var sfx_stream: AudioStream

# 屏幕震动配置
@export_group("Screen Shake")
@export var shake_strength: float = 0.0
@export var shake_duration: float = 0.0

# 可以在这里添加其他效果类型，例如：
# @export var decal_texture: Texture2D