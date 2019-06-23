local leaves = "group:leaves"
local wood  = "group:wood"
local nada = ''
local stick = "group:stick"

local metal = {"tin", "copper", "bronze", 'gold', "steel"} 
local armor = {'boots', 'chestplate', "leggings", "helmet"}
local qty_a = {4, 8, 7, 5} -- qty metal to make the 3d armor

local tools = {'pick', 'axe', 'shovel', 'sword'}
local qty_t = {3, 3, 1, 2} -- qty metal to make tools

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
	for i=4,#metal do
		local outer='default:'..metal[i]..'_ingot'
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
	for i=3,#metal do
		for j=1,#tools do 
			local namer='default:'..tools[j]..'_'..metal[i]
			local outer='default:'..metal[i]..'_ingot'
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
			recipe = {
				{"gravelsieve:compressed_gravel"},
			},
		})
	end
end -- decompress sieved gravel block

-- decompress fuel canister -- biofuels mod
if minetest.settings:get_bool("biofuels_decomp") ~= false then
	minetest.log('LOADING Uncompress canister')
	if minetest.registered_items["biofuel:fuel_can"] then
		minetest.register_craft({
			output = "biofuel:bottle_fuel 9",
			recipe = {
				{"biofuel:fuel_can"},
			},
		})
	end
end -- decompress sieved gravel block



-- decompress magic block -- brewing mod
if minetest.settings:get_bool("magic_comp") ~= false then
	minetest.log('LOADING Uncompress Magic Block')
	if minetest.registered_items["brewing:magic_crystal"] then
		minetest.register_craft({
			output = "brewing:magic_crystal",
			recipe = {
				{"brewing:magic_block"},
			},
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
			max_items = 1,
			items = {
				{items = {"ts_tweaks:pine_nuts"}, rarity = 40},
				{items = {"default:pine_sapling"}, rarity = 15},
				{items = {"default:pine_needles"}},
			}
		},
	})
end -- pine nuts


-- wooden_bucket mod
if minetest.settings:get_bool("wooden_bucket_recipe") ~= false then
	minetest.log('LOADING Wooden Bucket Recipe')
	if minetest.registered_items["bucket_wooden:bucket_empty"] then
-- add recipe for wooden_bucket so it doesn't conflict with farming_redo or ethereal
		minetest.register_craft({
			output = 'bucket_wooden:bucket_empty',
			recipe = {
				{wood, leaves, wood},
				{nada, wood, nada},
			}
		})
	end
end -- wooden_bucket mod



-- basic materials
if minetest.settings:get_bool("basic_materials_oil_rebalance") ~= false then
	minetest.log('LOADING Basic Materials Rebalancing')
	if minetest.registered_items["basic_materials:oil_extract"] then
		minetest.register_craft({
			type = "fuel",
			recipe = "basic_materials:oil_extract",
			burntime = 9})
	end


	if minetest.registered_items["basic_materials:paraffin"] then
		minetest.register_craft({
			type = "fuel",
			recipe = "basic_materials:oil_extract",
			burntime = 9})
	end



-- A use for extra seeds!
	minetest.register_craft({
		type = "shapeless",
		output = "basic_materials:oil_extract 2",
		recipe = {
			"group:seed","group:seed","group:seed",
			"group:seed","group:seed","group:seed"
		}
	})
end -- basic materials

