@tool
extends EditorPlugin

const ADDON_NAME := "Generate class_name Hider Profile";
const ADDON_PATH := "addons/class_name_hider/"
const PATH_PROFILE := "res://hider_script.profile"	
const PATH_RES := "res://"
const PROFILE = """{
	"disabled_classes": [
%s
	],
	"disabled_editors": [],
	"disabled_features": [],
	"disabled_properties": [],
	"type": "feature_profile"
}
"""

var plugin_path_folders := ADDON_PATH.path_join("excluded_folders")
var excluded: PackedStringArray

func _enter_tree() -> void:
	if not ProjectSettings.has_setting(plugin_path_folders):
		var property_info := {
			"name": plugin_path_folders,
			"type": TYPE_PACKED_STRING_ARRAY,
		}
		
		var arr: PackedStringArray = ["addons"]
		
		ProjectSettings.set_setting(plugin_path_folders, arr)
		ProjectSettings.add_property_info(property_info)
		
	add_tool_menu_item(ADDON_NAME, _create_autoload)


func _exit_tree() -> void:
	remove_tool_menu_item(ADDON_NAME)


func _create_autoload() -> void:
	var profile: String
	var dir_array := get_all_scripts(PATH_RES)
	
	excluded = ProjectSettings.get_setting(plugin_path_folders) as PackedStringArray
	excluded.append("class_name_hider")
	
	for dir in dir_array:
		var script_class_name = dir.get_file().get_slice(".", 0).to_pascal_case()
		var script := load(dir) as Script
		
		if script.new() is Node:
			profile += "\t\t\"%s\",\n" % script_class_name
	
	profile = profile.trim_suffix(",\n")
	profile = PROFILE % profile
	
	var file := FileAccess.open(PATH_PROFILE, FileAccess.WRITE)
	file.store_string(profile)
	file.close()
	
	print_verbose(profile)
	print("[Global Script Access] Profile created!")


func get_all_scripts(path: String) -> Array[String]:
	var array: Array[String] = []
	
	var dir = DirAccess.open(path)
	dir.include_hidden = false
	dir.include_navigational = false
	
	if dir:
		dir.list_dir_begin()
		
		var file_name = dir.get_next()
		
		while file_name != "":
			if dir.current_is_dir() and not is_excluded(file_name):
				var subfolder_array = get_all_scripts(path.path_join(file_name))
				
				array.append_array(subfolder_array)
				
			elif file_name.get_extension() == "gd":
				array.append(path.path_join(file_name))
				
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
		
		return []
	
	return array


func is_excluded(name: String) -> bool:
	for dir in excluded:
		if dir == name:
			return true
	
	return false
