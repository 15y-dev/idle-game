class_name UpgradeData
extends Resource

@export var name: String = ""
@export var description: String = ""
@export var cost: float = 10.0
@export var cps_bonus: float = 0.1
@export var unlocked: bool = false
var count: int = 0  # セーブ対象
