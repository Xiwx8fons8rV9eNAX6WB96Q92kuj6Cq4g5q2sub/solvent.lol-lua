local library =
	loadstring(game:HttpGet("https://esex.rocks/p/raw/yb0xww3tya"))()
local flags = library.flags

local exec_name = "unknown"
pcall(function()
	local a, b = identifyexecutor()
	if a and a ~= "" then
		exec_name = string.lower(a)
	elseif b and b ~= "" then
		exec_name = string.lower(b)
	end
end)

local players = game:GetService("Players")
local local_player = players.LocalPlayer
local lp = local_player
local old_config = library.get_config and library:get_config() or nil

local window = library:window({
	name = "solvent - " .. tostring(exec_name),
	size = UDim2.fromOffset(600, 450),
})

do
	local configs = window:tab({ name = "configs" })
	
	local config = configs:section({ name = "theming", side = "right" })
	
	config:toggle({
		name = "keybind list",
		flag = "keybind_list",
		default = false,
		callback = function(bool)
			window.toggle_list(bool)
		end,
	})
	
	config:toggle({
		name = "watermark",
		flag = "watermark",
		default = true,
		callback = function(bool)
			window.toggle_watermark(bool)
		end,
	})
	
	config:keybind({
		name = "ui bind",
		default = Enum.KeyCode.Insert,
		display = "menu",
		callback = window.set_menu_visibility,
	})
	
	config:slider({
		name = "colorpicker animation speed",
		flag = "color_picker_anim_speed",
		min = 0,
		max = 5,
		default = 2,
		interval = 0.01,
	})
	
	config:colorpicker({
		color = Color3.fromRGB(247, 190, 255),
		flag = "accent",
		callback = function(color)
			library:update_theme("accent", color)
		end,
	})
	
	config:button({
		name = "copy jobid",
		callback = function()
			setclipboard(game.JobId)
		end,
	})
	config:button({
		name = "copy gameid",
		callback = function()
			setclipboard(game.GameId)
		end,
	})
	config:button({
		name = "rejoin",
		callback = function()
			game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, lp)
		end,
	})

	local configs_section = configs:section({ name = "configuration system", side = "left" })

	if not library.directory then
		library.directory = ""
	end
	
	local dir = library.directory .. "/configs/"
	
	library.config_holder = configs_section:dropdown({ name = "configs", items = {}, flag = "config_name_list" })
	
	configs_section:textbox({ flag = "config_name_text_box" })
	
	configs_section:button({
		name = "create",
		callback = function()
			writefile(dir .. flags["config_name_text_box"] .. ".cfg", library:get_config())
			if library.config_list_update then
				pcall(function()
					library:config_list_update()
				end)
			end
		end,
	})
	
	configs_section:button({
		name = "delete",
		callback = function()
			library:panel({
				name = "are you sure you want to delete " .. flags["config_name_list"] .. " ?",
				options = { "yes", "no" },
				callback = function(option)
					if option == "yes" then
						delfile(dir .. flags["config_name_list"] .. ".cfg")
						if library.config_list_update then
							pcall(function()
								library:config_list_update()
							end)
						end
					end
				end,
			})
		end,
	})
	
	configs_section:button({
		name = "load",
		callback = function()
			library:load_config(readfile(dir .. flags["config_name_list"] .. ".cfg"))
		end,
	})
	
	configs_section:button({
		name = "save",
		callback = function()
			writefile(dir .. flags["config_name_text_box"] .. ".cfg", library:get_config())
			if library.config_list_update then
				pcall(function()
					library:config_list_update()
				end)
			end
		end,
	})
	
	configs_section:button({
		name = "unload config",
		callback = function()
			library:load_config(old_config)
		end,
	})
	
	configs_section:button({
		name = "unload menu",
		callback = function()
			library:unload()
		end,
	})

	if library.config_list_update then
		pcall(function()
			library:config_list_update()
		end)
	end
end
