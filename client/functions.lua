TriggerEvent("getCore", function(core)
    VORPcore = core
end)

--########################## LOAD MODEL ##########################
function LoadModel(model)
    local modelHash = joaat(model)

    if IsModelValid(model) and not HasModelLoaded(modelHash) then
        RequestModel(modelHash)
        while not HasModelLoaded(modelHash) do
            Wait(0)
        end
    end
end

--########################## SET CLOTH ##########################
function RemoveTagFromMetaPed(category)
    if category == "Coat" then
        Citizen.InvokeNative(0xD710A5007C2AC539, PlayerPedId(), ClothingCategories.CoatClosed, 0)
    end
    if category == "CoatClosed" then
        Citizen.InvokeNative(0xD710A5007C2AC539, PlayerPedId(), ClothingCategories.Coat, 0)
    end
    if category == "Pant" then
        if not IsPedMale(PlayerPedId()) then
            Citizen.InvokeNative(0xD710A5007C2AC539, PlayerPedId(), ClothingCategories.Skirt, 0)
        end
        Citizen.InvokeNative(0xD710A5007C2AC539, PlayerPedId(), ClothingCategories.Boots, 0)
    end
    if category == "Skirt" and not IsPedMale(PlayerPedId()) then
        Citizen.InvokeNative(0xD710A5007C2AC539, PlayerPedId(), ClothingCategories.Pant, 0)
    end

    Citizen.InvokeNative(0xD710A5007C2AC539, PlayerPedId(), ClothingCategories[category], 0)
    UpdateVariation(PlayerPedId())
end

function ApplyShopItemToPed(comp, category)
    RemoveTagFromMetaPed(category)
    Citizen.InvokeNative(0xD3A7B003ED343FD9, PlayerPedId(), comp, false, false, false)
    Citizen.InvokeNative(0xD3A7B003ED343FD9, PlayerPedId(), comp, false, true, false)
    Citizen.InvokeNative(0x66b957aac2eaaeab, PlayerPedId(), comp, 0, 0, 1, 1) -- _UPDATE_SHOP_ITEM_WEARABLE_STATE
    Citizen.InvokeNative(0xAAB86462966168CE, PlayerPedId(), 1)        --_CLEAR
    UpdateVariation(PlayerPedId())
end

function UpdateVariation(ped)
    Citizen.InvokeNative(0xCC8CA3E88256E58F, ped, false, true, true, true, false)
    IsPedReadyToRender()
end

function IsPedReadyToRender()
    Citizen.InvokeNative(0xA0BC8FAED8CFEB3C, PlayerPedId())
    while not Citizen.InvokeNative(0xA0BC8FAED8CFEB3C, PlayerPedId()) do
        Citizen.InvokeNative(0xA0BC8FAED8CFEB3C, PlayerPedId())
        Wait(0)
    end
end

--########################## OVERLAY ##########################
function FaceOverlay(name, visibility, tx_id, tx_normal, tx_material, tx_color_type, tx_opacity, tx_unk, palette_id,
					 palette_color_primary, palette_color_secondary, palette_color_tertiary, var, opacity)
	local visibility = visibility or 0
	local tx_id = tx_id or 0
	local palette_color_primary = palette_color_primary or 0
	local opacity = opacity or 1.0


	for k, v in pairs(overlay_all_layers) do
		if v.name == name then
			v.visibility = visibility
			if visibility ~= 0 then
				v.tx_normal = tx_normal
				v.tx_material = tx_material
				v.tx_color_type = tx_color_type
				v.tx_opacity = tx_opacity
				v.tx_unk = tx_unk

				if tx_color_type == 0 then
					v.palette = color_palettes[name][palette_id]
					v.palette_color_primary = palette_color_primary == 0 and 0x3F6E70FF or palette_color_primary
					v.palette_color_secondary = palette_color_secondary or 0
					v.palette_color_tertiary = palette_color_tertiary or 0
				end

				v.var = 0
				v.tx_id = tx_id == 0 and Makeup[name][1].id or Makeup[name][tx_id].id

				if name == "shadows" or name == "eyeliners" or name == "lipsticks" then
					v.var = var or 0
					v.tx_id = Makeup[name][1].id
				end

				v.opacity = opacity == 0 and 1.0 or opacity

				if name == "grime" then
					v.visibility = 0
				end
			end
		end
	end
end

local textureId = -1

function toggleOverlayChange(name, visibility, tx_id, tx_normal, tx_material, tx_color_type, tx_opacity, tx_unk, palette_id, palette_color_primary, palette_color_secondary, palette_color_tertiary, var, opacity, albedo)
    for k, v in pairs(overlay_all_layers) do
        if v.name == name then
            v.visibility = visibility
            if visibility ~= 0 then
                v.tx_normal = tx_normal
                v.tx_material = tx_material
                v.tx_color_type = tx_color_type
                v.tx_opacity = tx_opacity
                v.tx_unk = tx_unk
                if tx_color_type == 0 then
                    v.palette = color_palettes[name][palette_id]
                    v.palette_color_primary = palette_color_primary
                    v.palette_color_secondary = palette_color_secondary
                    v.palette_color_tertiary = palette_color_tertiary
                end
                if name == "shadows" or name == "eyeliners" or name == "lipsticks" then
                    v.var = var
                    if tx_id ~= 0 then
                        v.tx_id = Makeup[name][1].id
                    end
                else
                    v.var = 0
                    if tx_id ~= 0 then
                        v.tx_id = Makeup[name][tx_id].id
                    end
                end
                v.opacity = opacity
            end
        end
    end

    local gender = 'Female'

    if IsPedMale(PlayerPedId()) then
        gender = 'Male'
    end

    local current_texture_settings = texture_types[gender]

    if textureId ~= -1 then
        Citizen.InvokeNative(0xB63B9178D0F58D82, textureId) -- reset texture
        Citizen.InvokeNative(0x6BEFAA907B076859, textureId) -- remove texture
    end

    textureId = Citizen.InvokeNative(0xC5E7204F322E49EB, albedo, current_texture_settings.normal, current_texture_settings.material)    -- create texture

    for k, v in pairs(overlay_all_layers) do
        if v.visibility ~= 0 then
            local overlay_id = Citizen.InvokeNative(0x86BB5FF45F193A02, textureId, v.tx_id, v.tx_normal, v.tx_material, v.tx_color_type, v.tx_opacity, v.tx_unk)    -- create overlay
            if v.tx_color_type == 0 then
                Citizen.InvokeNative(0x1ED8588524AC9BE1, textureId, overlay_id, v.palette)  -- apply palette
                Citizen.InvokeNative(0x2DF59FFE6FFD6044, textureId, overlay_id, v.palette_color_primary, v.palette_color_secondary, v.palette_color_tertiary)   -- apply palette colours
            end

            Citizen.InvokeNative(0x3329AAE2882FC8E4, textureId, overlay_id, v.var)  -- apply overlay variant
            Citizen.InvokeNative(0x6C76BC24F8BB709A, textureId, overlay_id, v.opacity)  -- apply overlay opacity
        end
    end

    while not Citizen.InvokeNative(0x31DC8D3F216D8509, textureId) do -- wait till texture fully loaded
        Citizen.Wait(0)
    end

    Citizen.InvokeNative(0x92DAABA2C1C10B0E, textureId) -- update texture
    Citizen.InvokeNative(0x0B46E25761519058, PlayerPedId(), joaat("heads"), textureId)  -- apply texture to current component in category "heads"
    Citizen.InvokeNative(0xCC8CA3E88256E58F, PlayerPedId(), false, true, true, true, false) -- refresh ped components
end