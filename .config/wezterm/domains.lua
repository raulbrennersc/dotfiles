local wezterm = require("wezterm")
local hostname = wezterm.hostname()
local utils = require("utils")

local function setup(config)
	config.ssh_domains = {}
	config.unix_domains = {
		{
			name = hostname,
		},
	}

	local devcontainers = utils.get_devcontainers()
	for _, devcontainer in pairs(devcontainers) do
		local name = utils.split(devcontainer, "|")[1]
		local port = utils.split(devcontainer, "|")[2]
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
		config.default_domain = hostname
	end

	config.default_workspace = hostname
end

local function get_mux_domains()
	local mux_domains = {}
	local status, all_domains = pcall(wezterm.mux.all_domains)
	if not status then
		all_domains = {}
	end

	for _, domain in ipairs(all_domains) do
		local is_devcontainer = string.find(domain:name(), ".devcontainer")
		local is_host = domain:name() == hostname
		if is_devcontainer or is_host then
			table.insert(mux_domains, {
				label = domain:name(),
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
