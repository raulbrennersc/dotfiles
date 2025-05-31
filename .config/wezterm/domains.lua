local wezterm = require("wezterm")
local hostname = wezterm.hostname()

-- WTF why lua doesn't have built in string.split?!?!?!? I DON'T KNOW
-- split hack
local function split(input, separator)
	local t = {}
	for str in string.gmatch(input, "([^" .. separator .. "]+)") do
		table.insert(t, str)
	end
	return t
end

local function setup(config)
	config.ssh_domains = {}
	config.unix_domains = {
		{
			name = hostname,
		},
	}

	local handle = io.popen("devcontainer list")
	local devcontainers = split(string.gsub(handle:read("*a"), "\n", ""), " ")
	handle:close()

	for _, devcontainer in pairs(devcontainers) do
		local name = split(devcontainer, "|")[1]
		local port = split(devcontainer, "|")[2]
		local domain = {
			name = name,
			remote_address = "localhost",
			ssh_option = {
				hostname = "localhost",
				user = "dev",
				forwardx11 = "yes",
				forwardagent = "yes",
				port = port,
			},
		}

		table.insert(config.ssh_domains, domain)
	end

	config.default_gui_startup_args = { "connect", hostname }
	config.default_workspace = hostname
end

local function get_mux_domains()
	local mux_domains = {}
	local status, all_domains = pcall(wezterm.mux.all_domains)
	if not status then
		all_domains = {}
	end

	for _, value in ipairs(all_domains) do
		local is_devcontainer = string.find(value:name(), ".devcontainer")
		local is_host = value:name() == hostname
		if is_devcontainer or is_host then
			table.insert(mux_domains, {
				label = value:name(),
			})
		end
	end
	return mux_domains
end

local function switch_domain(window, pane, _, domain)
	window:perform_action(
		wezterm.action({
			SwitchToWorkspace = {
				name = domain,
				spawn = {
					domain = { DomainName = domain },
				},
			},
		}),
		pane
	)
end

return {
	setup = setup,
	get_mux_domains = get_mux_domains,
	switch_domain = switch_domain,
}
