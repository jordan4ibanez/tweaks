--inventory tweaks

--attributions: (inv_move) http://www.freesound.org/people/strange_dragoon/sounds/271140/

--play sound on craft
minetest.register_on_craft(function(itemstack, player, old_craft_grid, craft_inv)
	local pos = player:getpos()
	minetest.sound_play("tool_drop", {
		pos = pos,
		max_hear_distance = 100,
		gain = 10.0,
	})
	return(itemstack)
end)


--play sound on inventory move/drop/add

--eventually include the craft bench

lastinventory = {}
oldcount      = {} --last number of items player had
minetest.register_globalstep(function(dtime)
	for _,player in ipairs(minetest.get_connected_players()) do
		local inv           = player:get_inventory()
		local inventory     = inv:get_list("main")
		local oldinv = lastinventory[player:get_player_name()] 
		
		if oldinv ~= nil then
			local n = 1
			local count = 0
			--get the count of items
			for item in pairs(inventory) do
				local itemcount = inventory[n]:to_string()
				if itemcount ~= "" then
					count = count + inventory[n]:to_table().count
				end
				n = n + 1
			end

			n = 1
			
			--check if items have changed
			if oldcount[player:get_player_name()] ~= nil then
				if count == oldcount[player:get_player_name()] then
					for item in pairs(inventory) do
						local newitem = inventory[n]:to_string()
						local olditem = oldinv[n]:to_string()
						if newitem ~= olditem then
							minetest.sound_play("inv_move", {
								pos = pos,
								max_hear_distance = 100,
								gain = 10.0,
							})
							break
						end	
						n = n + 1
					end
				end
			end
			oldcount[player:get_player_name()] = count	
		end
		lastinventory[player:get_player_name()] = inventory
	end
end)
