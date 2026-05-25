# game_manager.gd
extends Node

@export var data: GameData
@export var cookie_label: Label
@export var cps_label: Label
@export var upgrade_list: VBoxContainer
@export var upgrade_item_scene: PackedScene

func _ready():
	if data == null:
		push_error("GameData が設定されていません")
		return

	var offline_seconds = SaveManager.load_data(data)
	data.cookies += data.cookies_per_second * offline_seconds  # 上限なし

	_build_upgrade_list()
	_update_ui()

	if offline_seconds > 1.0:
		print("オフライン時間: %.0f 秒 / 獲得: %.0f cookies" % [offline_seconds, data.cookies_per_second * offline_seconds])

func _on_timer_timeout():
	data.cookies += data.cookies_per_second
	_update_ui()
	SaveManager.save(data)  # 毎秒自動セーブ

func _on_click_button_pressed():
	data.cookies += 1.0
	_update_ui()

func _update_ui():
	cookie_label.text = "Cookies: %.0f" % data.cookies
	cps_label.text = "per second: %.1f" % data.cookies_per_second
	for child in upgrade_list.get_children():
		child.update_affordability(data.cookies)

func _build_upgrade_list():
	for upgrade in data.upgrades:
		var item = upgrade_item_scene.instantiate()
		item.data = upgrade
		item.count = upgrade.count  # ロードした購入数を反映
		item.pressed.connect(_on_upgrade_purchased.bind(upgrade, item))
		upgrade_list.add_child(item)

func _on_upgrade_purchased(upgrade: UpgradeData, item):
	if data.cookies < upgrade.cost:
		return
	data.cookies -= upgrade.cost
	data.cookies_per_second += upgrade.cps_bonus
	upgrade.count += 1
	item.purchased()
	_update_ui()

func _on_reset_button_pressed():
	var dialog = ConfirmationDialog.new()
	dialog.dialog_text = "本当にリセットしますか？"
	add_child(dialog)
	dialog.popup_centered()
	dialog.confirmed.connect(func():
		SaveManager.reset(data)
		for child in upgrade_list.get_children():
			child.queue_free()
		_build_upgrade_list()
		_update_ui()
	)
