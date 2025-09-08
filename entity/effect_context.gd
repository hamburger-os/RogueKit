# EffectContext
# A data container for passing information to an EffectData's execute method.
class_name EffectContext
extends RefCounted

# The entity that initiated the effect.
var attacker: Node

# The primary target of the effect.
var target: Node

# The ability that triggered this effect, if any.
var source_ability: Resource

# A dictionary for additional, arbitrary data that effects might need.
# For example: { "damage_dealt": 10, "is_critical": true }
var metadata: Dictionary = {}

func _init(p_attacker: Node, p_target: Node, p_source_ability: Resource = null, p_metadata: Dictionary = {}):
	self.attacker = p_attacker
	self.target = p_target
	self.source_ability = p_source_ability
	self.metadata = p_metadata