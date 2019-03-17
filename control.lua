
local function serialize(t)
	local s = {}
	for k,v in pairs(t) do
		if type(v) == "table" then
			v = serialize(v)
		end
		s[#s+1] = tostring(k).." = "..tostring(v)
	end
	return "{ "..table.concat(s, ", ").." }"
end

local function check_state(force)
	if not global[force.index] then
		global[force.index] = {}
	end
end

local function check_channels()
	for team,channels in pairs(global) do
		for channel,link in pairs(channels) do
			local nodes = link.circuit_connected_entities
			if #nodes.red == 0 and #nodes.green == 0 then
				log("close channel "..channel)
				link.destroy()
				channels[channel] = nil
			end
		end
	end
end

local function radio_link(radio)

	local links = radio.surface.find_entities_filtered({
		name = "shortwave-link",
		area = {
			{ x = radio.position.x - 0.25, y = radio.position.y - 0.25, },
			{ x = radio.position.x + 0.25, y = radio.position.y + 0.25, },
		},
	})

	local link = links and links[1]

	if not link then
		link = radio.surface.create_entity({
			name = "shortwave-link",
			position = radio.position,
			force = radio.force,
		})
	end

	link.operable = false

	return link
end

local function radio_port(radio)

	local ports = radio.surface.find_entities_filtered({
		name = "shortwave-port",
		area = {
			{ x = radio.position.x - 0.25, y = radio.position.y - 0.25, },
			{ x = radio.position.x + 0.25, y = radio.position.y + 0.25, },
		},
	})

	local ghosts = radio.surface.find_entities_filtered({
		ghost_name = "shortwave-port",
		area = {
			{ x = radio.position.x - 0.25, y = radio.position.y - 0.25, },
			{ x = radio.position.x + 0.25, y = radio.position.y + 0.25, },
		},
	})

	local port = ports and ports[1]

	if not port and ghosts and ghosts[1] then
		_, port = ghosts[1].revive()
		table.remove(ghosts, 1)
		log("revive port "..port.unit_number)
	end

	if not port then
		port = radio.surface.create_entity({
			name = "shortwave-port",
			position = radio.position,
			force = radio.force,
		})
		log("create port "..port.unit_number)
	end

	for _, ghost in ipairs(ghosts) do
		ghost.destroy()
		log("remove ghost "..ghost.unit_number)
	end

	port.operable = false
	port.direction = defines.direction.south

	return port
end

local function radio_tune(radio)
	local team = radio.force.index
	local link = radio_link(radio)
	local port = radio_port(radio)

	for _, l in ipairs(link.circuit_connected_entities.red) do
		if l.name == "shortwave-link" then
			link.disconnect_neighbour({
				wire = defines.wire_type.red,
				target_entity = l,
			})
		end
	end

	for _, l in ipairs(link.circuit_connected_entities.green) do
		if l.name == "shortwave-link" then
			link.disconnect_neighbour({
				wire = defines.wire_type.green,
				target_entity = l,
			})
		end
	end

	local signal = radio.get_control_behavior().get_signal(1)

	if not signal or not signal.signal then
		return
	end

	local channel = signal.signal.name..":"..signal.count

	if not global[team][channel] then
		log("open channel "..channel)
		global[team][channel] = radio.surface.create_entity({
			name = "shortwave-link",
			position = { 0, 0 },
			force = radio.force,
		})
	end

	local relay = global[team][channel]

	log(serialize(port.circuit_connection_definitions))

	link.connect_neighbour({
		wire = defines.wire_type.red,
		target_entity = relay,
	})

	link.connect_neighbour({
		wire = defines.wire_type.green,
		target_entity = relay,
	})

	link.connect_neighbour({
		wire = defines.wire_type.red,
		target_entity = port,
		target_circuit_id = defines.circuit_connector_id.combinator_input,
	})

	link.connect_neighbour({
		wire = defines.wire_type.green,
		target_entity = port,
		target_circuit_id = defines.circuit_connector_id.combinator_input,
	})
end

local function OnEntityCreated(event)
	local entity = event.created_entity

	if not entity or not entity.valid then
		return
	end

	if entity.name == "shortwave-radio" then
		check_state(entity.force)
		radio_tune(entity)
		check_channels()
	end
end

local function OnEntityRemoved(event)
	local entity = event.entity

	if not entity or not entity.valid then
		return
	end

	if entity.name == "shortwave-radio" then
		check_state(entity.force)
		radio_link(entity).destroy()
		radio_port(entity).destroy()
		check_channels()
	end
end

script.on_init(function()
	script.on_event({defines.events.on_built_entity, defines.events.on_robot_built_entity}, OnEntityCreated)
	script.on_event({defines.events.on_player_mined_entity, defines.events.on_robot_pre_mined, defines.events.on_entity_died}, OnEntityRemoved)
end)

script.on_load(function()
	script.on_event({defines.events.on_built_entity, defines.events.on_robot_built_entity}, OnEntityCreated)
	script.on_event({defines.events.on_player_mined_entity, defines.events.on_robot_pre_mined, defines.events.on_entity_died}, OnEntityRemoved)
end)

script.on_event({defines.events.on_gui_closed}, function(event)
	if event.entity and event.entity.name == "shortwave-radio" then
		check_state(event.entity.force)
		radio_tune(event.entity)
		check_channels()
	end
end)

script.on_event({defines.events.on_entity_settings_pasted}, function(event)
	if event.destination and event.destination.name == "shortwave-radio" then
		check_state(event.destination.force)
		radio_tune(event.destination)
		check_channels()
	end
end)