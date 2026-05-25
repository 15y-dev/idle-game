extends Node

const SAVE_PATH = "user://save.cfg"

func save(data: GameData):
	var config = ConfigFile.new()
	config.set_value("game", "cookies", data.cookies)
	config.set_value("game", "cookies_per_second", data.cookies_per_second)
	config.set_value("game", "last_save_time", Time.get_unix_time_from_system())

	for i in data.upgrades.size():
		config.set_value("upgrades", str(i) + "_count", data.upgrades[i].count)

	config.save(SAVE_PATH)

func load_data(data: GameData) -> float:
	var config = ConfigFile.new()
	if config.load(SAVE_PATH) != OK:
		return 0.0

	data.cookies = config.get_value("game", "cookies", 0.0)
	data.cookies_per_second = config.get_value("game", "cookies_per_second", 0.0)

	for i in data.upgrades.size():
		data.upgrades[i].count = config.get_value("upgrades", str(i) + "_count", 0)

	# オフライン時間を計算して返す
	var last_save = config.get_value("game", "last_save_time", 0.0)
	var offline_seconds = Time.get_unix_time_from_system() - last_save
	return offline_seconds

func reset(data: GameData):
	data.cookies = 0.0
	data.cookies_per_second = 0.0
	for upgrade in data.upgrades:
		upgrade.count = 0

	if FileAccess.file_exists(SAVE_PATH):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(SAVE_PATH))
