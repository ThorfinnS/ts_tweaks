local leaves = "group:leaves"
local wood  = "group:wood"
local nada = ''
local stick = "group:stick"
local seeds = "group:seed"
local modname = minetest.get_current_modname()
local modpath = minetest.get_modpath(modname)


local metal = {"tin", "copper", "bronze", 'gold', "steel", "stone", "mese", "diamond"} 
local armor = {'boots', 'chestplate', "leggings", "helmet"}
local qty_a = {4, 8, 7, 5} -- qty metal to make the 3d armor

local tools = {'pick', 'axe', 'shovel', 'sword', "hoe"}
local qty_t = {3, 3, 1, 2, 2} -- qty metal to make tools

local function smelt_item(in_,out_,qty_)
	-- if minetest.registered_items[in_] then 
		out_=out_..' '..tostring(qty_)
		minetest.register_craft({
			type = "cooking",
			output = out_,
			recipe = in_,
			cooktime = qty_*3
		})
	-- end
end

local function burn_item(in_, qty_)
	if minetest.registered_items[in_] then
		minetest.register_craft({
			type = "fuel",
			recipe = in_,
			burntime = qty_
		})
	end
end

local function decon_rail_fence(in_)
	if minetest.registered_items[in_] then
		minetest.register_craft({
			-- type = "shapeless",
			output="default:stick 2",
			recipe = {{in_}}
		})
	end
end

local function cool_trees_slabs(in_)
	local wood_,slab_,trunk_=in_..':wood', 'stairs:slab_'..in_..'_trunk', in_..':trunk'
	if minetest.registered_items[wood_] and minetest.registered_items[slab_] then
		minetest.clear_craft({recipe={{trunk_, trunk_, trunk_}}})
		minetest.register_craft({
			type = "shapeless",
			output=slab_..' 6',
			recipe = {wood_,wood_,wood_}})
		minetest.clear_craft({recipe={{slab_},{slab_}}})
		minetest.register_craft({
			type = "shapeless",
			output=wood_,
			recipe = {slab_,slab_}})
	end
end


-- ---------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------
-- -------------------BEGIN MAIN CODE BLOCK-----------------------------------------------
-- ---------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------



-- burnable wood armor, burntime=4 per plank -- 3d armor mod
if minetest.settings:get_bool("3d_armor_burn_wood") ~= false then
	minetest.log('LOADING Burnable 3D Wood Armor')
	for i=1, #armor do
		burn_item('3d_armor:'..armor[i]..'_wood',qty_a[i]*4)
	end
	burn_item('shields:shield_wood',28)
end -- burnable wood armor



-- smelt 3D armor
if minetest.settings:get_bool("scrap_3d_armor") ~= false then
	minetest.log('LOADING Smelt 3D Armor')
	for i=1,#metal do
		local suffix=''
		if i<=5 then --metals, so output ingots
			suffix='_ingot'
		end
		local outer='default:'..metal[i]..suffix
		for j=1,#armor do 
			local namer='3d_armor:'..armor[j]..'_'..metal[i]
			smelt_item(namer, outer, qty_a[j])
		end
		smelt_item('shields:shield_'..metal[i],outer,7)
	end
end -- smelt 3d armor


-- smelt tools
if minetest.settings:get_bool("scrap_tools") ~= false then
	minetest.log('LOADING Smelt Tools')
	for i=1,#metal do
		for j=1,#tools do 
			local namer, suffix='default:'..tools[j]..'_'..metal[i],''
			if i<=5 then --metals, so output ingots
				suffix='_ingot'
			end
			local outer='default:'..metal[i]..suffix
			smelt_item(namer, outer, qty_t[j])
		end
	end
	smelt_item('screwdriver:screwdriver', 'default:steel_ingot', 1)
end -- smelt tools


-- decompress sieved gravel block -- gravel sieve mod
if minetest.settings:get_bool("gravel_comp") ~= false then
	minetest.log('LOADING Uncompress Gravel Block')
	if minetest.registered_items["gravelsieve:compressed_gravel"] then
		minetest.register_craft({
			output = "gravelsieve:sieved_gravel 4",
			recipe = {{"gravelsieve:compressed_gravel"}}
		})
	end
end -- decompress sieved gravel block

-- deconstruct trellis and bean pole -- farming redo mod
if minetest.settings:get_bool("farm_trellis") ~= false then
	minetest.log('LOADING Deconstruct Trellis and Bean Pole')
	if minetest.registered_items["farming:trellis"] then
		minetest.register_craft({
			output = "default:stick 9",
			recipe = {{"farming:trellis"}}
		})
	end
	if minetest.registered_items["farming:beanpole"] then
		minetest.register_craft({
			output = "default:stick 4",
			recipe = {{"farming:beanpole"}}
		})
	end
end -- deconstruct trellis and bean pole



-- decompress fuel canister -- biofuels mod
if minetest.settings:get_bool("biofuels_decomp") ~= false then
	minetest.log('LOADING Uncompress biofuels canister')
	if minetest.registered_items["biofuel:fuel_can"] then
		minetest.register_craft({
			output = "biofuel:bottle_fuel 9",
			recipe = {{"biofuel:fuel_can"}}
		})
	end
end -- decompress sieved gravel block



-- decompress magic block -- brewing mod
if minetest.settings:get_bool("magic_comp") ~= false then
	minetest.log('LOADING Uncompress Magic Block')
	if minetest.registered_items["brewing:magic_crystal"] then
		minetest.register_craft({
			output = "brewing:magic_crystal",
			recipe = {{"brewing:magic_block"}}
		})
	end
end -- decompress magic block



-- pine needles might be pine nuts instead
if minetest.settings:get_bool("pine_nuts") ~= false then
	minetest.log('LOADING Pine Nuts')
	minetest.register_craftitem("ts_tweaks:pine_nuts", {
		description = "Pine Nuts",
		inventory_image = "pine_nuts.png",
		on_use = minetest.item_eat(1),
		sounds = default.node_sound_leaves_defaults()
	})


	minetest.override_item("default:pine_needles", {
		drop = {
			-- max_items = 1,
			items = {
				{items = {"ts_tweaks:pine_nuts"}, rarity = 40},
				{items = {"default:pine_sapling"}, rarity = 15},
				{items = {"default:pine_needles"}},
			}
		},
	})
end -- pine nuts

-- recycle steel items
local s_ing, s_lad, s_bar ="default:steel_ingot", "default:ladder_steel", "xpanes:bar_flat"
minetest.register_craft({
	type="shapeless",
	output = s_ing,
	recipe = {s_lad,s_lad}
})

minetest.register_craft({
	type="shapeless",
	output = s_ing..' 3',
	recipe = {s_bar,s_bar,s_bar,s_bar,s_bar,s_bar,s_bar,s_bar}
})
-- END recycle steel items

--Duane R's bed mod
beds.register_bed(modname..':nest', {
	description = 'Nest of Leaves',
	tiles = {
		bottom = {'default_leaves.png^[noalpha'},
		top = {'default_leaves.png^[noalpha'},
	},
	inventory_image = 'default_leaves.png',
	wield_image = 'default_leaves.png',
	nodebox = {
		bottom = {-0.5, -0.5, -0.5, 0.5, -0.3, 0.5},
		top = {-0.5, -0.5, -0.5, 0.5, -0.3, 0.5},
	},
	selectionbox = {-0.5, -0.5, -0.5, 0.5, -0.3, 0.5},
	recipe = {
		{leaves, leaves},
		{leaves, leaves},
	},
})

  --END Duane R's bed mod



-- wooden_bucket mod
if minetest.settings:get_bool("wooden_bucket_recipe") ~= false then
	local bowl="farming:bowl"
	local buck="bucket_wooden:bucket_empty"
	minetest.log('LOADING Wooden Bucket Recipe')
	if minetest.registered_items[buck] then
-- add recipe for wooden_bucket so it doesn't conflict with farming_redo or ethereal
		minetest.register_craft({
			output = buck,
			recipe = {{wood, leaves, wood},{nada, wood, nada}}
		})
	end
	
	if minetest.registered_items[bowl] then
-- make buckets out of 4 bowls
		minetest.register_craft({
			output = buck,
			recipe = {{bowl, bowl, bowl},{nada, bowl, nada}}
		})
	end

end -- wooden_bucket mod

--rail fences
if minetest.registered_items["default:fence_rail_wood"] then
	decon_rail_fence('default:fence_rail_wood')
	decon_rail_fence('default:fence_rail_acacia_wood')
	decon_rail_fence('default:fence_rail_junglewood')
	decon_rail_fence('default:fence_rail_pine_wood')
	decon_rail_fence('default:fence_rail_aspen_wood')
	minetest.register_craft({
			type = "shapeless",
			output = "default:fence_rail_wood",
			recipe = {stick, stick}
		})
end --rail fences

-- --cool trees slabs
cool_trees_slabs('birch')
cool_trees_slabs('cherrytree')
cool_trees_slabs('chestnuttree')
cool_trees_slabs('clementinetree')
cool_trees_slabs('ebony')
cool_trees_slabs('jacaranda')
cool_trees_slabs('larch')
cool_trees_slabs('lemontree')
cool_trees_slabs('mahogany')
cool_trees_slabs('palm')


-- basic materials
if minetest.settings:get_bool("basic_materials_oil_rebalance") ~= false then
	minetest.log('LOADING Basic Materials Rebalancing')

--shorten burn times
	if minetest.registered_items["basic_materials:oil_extract"] then
		minetest.register_craft({
			type = "fuel",
			recipe = "basic_materials:oil_extract",
			burntime = 10})
	end

	if minetest.registered_items["basic_materials:paraffin"] then
		minetest.register_craft({
			type = "fuel",
			recipe = "basic_materials:oil_extract",
			burntime = 10})
	end

--reduce leaf to oil ratio
	if minetest.registered_items["basic_materials:oil_extract"] then
		minetest.clear_craft({recipe={{leaves,leaves,leaves},{leaves,leaves,leaves}}})
		minetest.register_craft({
			type = "shapeless",
			output = "basic_materials:oil_extract",
			recipe = {leaves,leaves,leaves,leaves,leaves,leaves}
		})
--add seed to oil at twice the rate of leaf to oil
	minetest.register_craft({
		type = "shapeless",
		output = "basic_materials:oil_extract 2",
		recipe = {seeds,seeds,seeds,seeds,seeds,seeds}
	})
	end

elseif minetest.registered_items["basic_materials:oil_extract"] then
--add seed to oil ratio to twice that of leaf to oil, no rebalancing
	minetest.register_craft({
		type = "shapeless",
		output = "basic_materials:oil_extract 4",
		recipe = {seeds,seeds,seeds,seeds,seeds,seeds}
	})
end -- basic materials

if minetest.registered_items["desert_life:prickly_pear"] then
	local pp_eat=modname..':prickly_pear_cooked'

	minetest.register_node(pp_eat, {
		description = "Cooked Prickly Pear",
		drawtype = 'mesh',
		mesh = 'dl_pp_1.obj',
		tiles = {name='prickly_pear_cooked.png'},
		-- tiles = {"prickly_pear_cooked.png"},
		-- is_ground_content = true,
		groups = {dig_immediate = 3},
		on_use = minetest.item_eat(1)
	})

	-- minetest.register_craftitem(pp_eat, {
		-- description = "Cooked Prickly Pear",
		-- inventory_image = "prickly_pear_cooked.png",
		-- on_use = minetest.item_eat(1),
		-- -- sounds = default.node_sound_leaves_defaults()
	-- })

	minetest.register_craft({
		type = "cooking",
		output = pp_eat,
		recipe = "desert_life:prickly_pear",
		cooktime = 1
	})
end


minetest.register_craft({
	output = "dye:orange",
	recipe = {
		{"farming:carrot"},
	}
})

minetest.register_craft({
	output = "dye:blue",
	recipe = {
		{"group:food_blueberries"},
	}
})

minetest.register_craft({
	output = "dye:red",
	recipe = {
		{"group:food_raspberries"},
	}
})

if minetest.get_modpath("hopper") and minetest.get_modpath("backpacks") then
	minetest.log('Support for hopper and backpacks')
	hopper:add_container({
		{"top", "backpacks:backpack_wool_white", "main"},
		{"bottom", "backpacks:backpack_wool_white", "main"},
		{"side", "backpacks:backpack_wool_white", "main"},
	})
else
	minetest.log('Support for hopper and backpacks nit installed')
end
