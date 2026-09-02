extends Node

const SAVE_PATH = "user://save_config_file.ini"
var config_save = ConfigFile.new()
var config_load = ConfigFile.new()
func save_level_1_complete():
	config_save.load(SAVE_PATH)
	config_save.set_value("level", "level_1_complete", true)
	config_save.save(SAVE_PATH)
func save_level_2_complete():
	config_save.load(SAVE_PATH)
	config_save.set_value("level", "level_2_complete", true)
	config_save.save(SAVE_PATH)
func save_level_3_complete():
	config_save.load(SAVE_PATH)
	config_save.set_value("level", "level_3_complete", true)
	config_save.save(SAVE_PATH)

func load_level_1_complete():
	config_load.load(SAVE_PATH)
	var level_1_complete = config_load.get_value("level", "level_1_complete", false)
	return level_1_complete
func load_level_2_complete():
	config_load.load(SAVE_PATH)
	var level_2_complete = config_load.get_value("level", "level_2_complete", false)
	return level_2_complete
func load_level_3_complete():
	config_load.load(SAVE_PATH)
	var level_3_complete = config_load.get_value("level", "level_3_complete", false)
	return level_3_complete
