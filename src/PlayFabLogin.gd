extends Node

# I don't fully understand Godot imports, i.e. why I need to manually preload this
# But this works!
var UUID = preload("res://addons/godot-playfab/lib/crypto_uuid_v4/uuid.gd")

func _ready():
	var _error = PlayFabManager.client.connect("api_error", self, "_on_PlayFab_api_error")
	_error = PlayFabManager.client.connect("logged_in", self, "_on_logged_in")
		
	var uuid
	
	var config = ConfigFile.new()
	var loadErr = config.load("user://playfab.cfg")
	if loadErr == OK:
		# TODO: I'm not sure our default/null check works how I want
		uuid = config.get_value("User", "custom_id", null)
		if uuid == null:
			uuid = UUID.v4()
			config.set_value("User", "custom_id", uuid)
			config.save("user://playfab.cfg")
	else:
		uuid = UUID.v4()
		config.set_value("User", "custom_id", uuid)
		config.save("user://playfab.cfg")

	PlayFabManager.client.login_with_custom_id(uuid, true, GetPlayerCombinedInfoRequestParams.new())

func _on_PlayFab_api_error(error: ApiErrorWrapper):
	print_debug(error.errorMessage)
	
func _on_logged_in(login_result: LoginResult):
	print_debug("Logged in", login_result.PlayFabId)
