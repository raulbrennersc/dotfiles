local wezterm = require("wezterm")

-- WTF why lua doesn't have built in string.split?!?!?!? I DON'T KNOW
-- split hack
local function split(input, separator)
	local t = {}
	for str in string.gmatch(input, "([^" .. separator .. "]+)") do
		table.insert(t, str)
	end
	return t
end

local function get_devcontainers()
	local handle = io.popen("devcontainer list")
	local devcontainers = split(string.gsub(handle:read("*a"), "\n", ""), " ")
	handle:close()
	return devcontainers
end

local function get_os_icon(pane)
	local handle = io.popen("cat /etc/os-release")
	local os_release = string.gsub(handle:read("*a"), "\n", "")
	handle:close()
	if string.find(pane:get_domain_name(), ".devcontainer") then
		return wezterm.nerdfonts.cod_code
	elseif string.find(os_release, "arch") then
		return wezterm.nerdfonts.linux_archlinux
	elseif string.find(os_release, "debian") then
		return wezterm.nerdfonts.linux_debian
	end
end

return { get_os_icon = get_os_icon, split = split, get_devcontainers = get_devcontainers }
