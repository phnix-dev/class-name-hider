# Class Name Hider - Godot Addon

This addon gives you access to global scripts using the `class_name` keyword, while removing the unwanted behaviour of user-created nodes in the `Create New Node` tab.

## Why

It is not very useful on its own, but it helps with this problem:

There are two ways to access the type of another script in one script.

The first is to `preload` the script into a constant, which makes you write `preload` a lot and can break because the path is hardcoded.

The second option is to use the `class_name` keyword. This lets you access the script type without preloading it. However, it makes the `Create New Node` tab cluttered, slows it down, and if the script only works in a specific scene, it will not load the scene when added with the `Create New Node` tab. Instead, it will add a new node with only the script attached to it.

## Note

- Note that this addon only **hides** the nodes in the `Create New Node` tab, it does not disable/remove them.
- The addon assumes that your scripts are in snake_case and the class_name name is the name of the script in PascalCase. (e.g. my_script.gd -> class_name MyScript)
- This addon is primarily intended for users who use the static typing (because duck typing is used with dynamic typing)

## Installation

1. Download the addon from GitHub or AssetLib.
2. Copy the addons folder into your project if you downloaded it from GitHub.
3. Enable the addons in your project settings.
4. By default, the addon hides all user-created scripts with the `class_name` keyword. To keep custom scripts in the `Create New Node` tab, add the folders **name** containing the scripts to the `class_name_hider/excluded_folders` settings.
5. Click on the button `Project > Tools > Generate class_name Hider Profile`.
6. Add the generated profile to the `Editor > Manage Editor Features...`, click on the `Import` button and select the `hider_script.profile`. Click on `Make current` if necessary.
7. The class hidden from the editor is in the `disabled_classes` array of the profile.

## License

This project is licensed under the terms of the [Mozilla Public License, version 2.0](https://www.mozilla.org/en-US/MPL/2.0/).
