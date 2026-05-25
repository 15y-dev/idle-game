extends Button

@export var data: UpgradeData

var count: int = 0

func _ready():
	_update_ui()

func _update_ui():
	if data == null:
		return
	%NameLabel.text = "%s  x%d" % [data.name, count]
	%CostLabel.text = "%.0f cookies" % data.cost
	%EffectLabel.text = "+%.1f/秒" % data.cps_bonus

func purchased():
	count += 1
	_update_ui()

func update_affordability(current_cookies: float):
	disabled = current_cookies < data.cost
	modulate = Color(1, 1, 1, 1) if current_cookies >= data.cost else Color(1, 1, 1, 0.4)
