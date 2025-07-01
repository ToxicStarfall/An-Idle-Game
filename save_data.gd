extends Resource
class_name SaveData

#region - - - Resources - - - - #
#@export var weapons: int = 0
#@export var weaponsE: int = 0
#@export var weaponPower: float = 0.0
#@export var weaponPowerE: float = 0.0
#@export var weaponsPC: float = 0.0
#@export var weaponsPS: float = 0
#@export var weaponsBasePC: int = 1
#@export var weaponsBasePS: int =


@export var power: float = 0.0             ## Total [Power] acumalated.
@export var powerE: float = 0.0            ## Total lifetime [Power] acumalated.
# @export var powerPC: float = 0.0
# @export var powerPCBase: float = 0.0
# @export var powerPCMult: float = 0.
@export var powerEarn: float = 0.0         ## Total [Power] earnt as part of [Thought] completion.
@export var powerEarnBase: int = 1         ## Base [Power] earnt per [Thought]
@export var powerEarnBasePct: float = 0.2  ## [Power] earnt as a % of [Knowledge] from [Thought].


@export var knowledge: float = 0
@export var knowledgeE: float = 0
#@export var knowledgePS: float = 0 #: set = _set_knowledgePS
#@export var knowledgeBasePS: int = 0

# Completing [Thoughts] grants [Knowledge].
@export var thoughtE: int = 0            ## Number of Thoughts completed.
@export var thoughtProgress: int = 0     ## Current completion progress of thought
@export var thoughtProgressReq: int = 0

@export var thoughtPower: float = 0
@export var thoughtPowerBase: int = 1
#@export var thoughtPowerMult: float = 1
#@export var thoughtPowerRand: float = 0.25  # Randomness of thought fill amount.

# Amount of earnt knowledge per Thought completed.
@export var thoughtEarn: float = 0
@export var thoughtEarnBase: int = 3
#@export var thoughtEarnMult: float = 1 #: set = _update_thoughtEarn
#@export var thoughtEarnRand: float = -0.25   # Randomness of earnt knowledge earnt per Thought
#@export var thoughtEarnRandMax: float = 0.1  # Randomness maximum
#@export var thoughtEarnScale: float = 1.2

#@export var currentResearch = null
#@export var currentResearchProgress = 0

#endregion


#region - - - Items - - - - #
@export var upgrades = {} # Dict{ Item }
@export var research = {}

@export var generator_cost_scale = 1.12 # 1.15 is used by cookieclicker
@export var generators = {}
#endregion
