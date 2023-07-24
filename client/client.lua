local data_store
local Character

--########################## PLAYERS ##########################
Citizen.CreateThread(function()
    while true do
        pcoords = GetEntityCoords(PlayerPedId())
        Wait(500)
    end
end)

--########################## CLOTHING STORES ##########################
local Cam

local StorePrompt
local StorePrompts = GetRandomIntInRange(0, 0xffffff)

Citizen.CreateThread(function()
    local str = _U('Open')
    StorePrompt = PromptRegisterBegin()
    PromptSetControlAction(StorePrompt, Config.KeyOpenClothingStore)
    str = CreateVarString(10, 'LITERAL_STRING', str)
    PromptSetText(StorePrompt, str)
    PromptSetEnabled(StorePrompt, 1)
    PromptSetVisible(StorePrompt, 1)
	PromptSetHoldMode(StorePrompt, 1000)
	PromptSetGroup(StorePrompt, StorePrompts)
	PromptRegisterEnd(StorePrompt)
end)

Citizen.CreateThread(function()
	for i, v in pairs(Config.ClothingStores) do
        if v.Blip.Enable then
            v.BlipHandle = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, v.NPC.Coords.x, v.NPC.Coords.y, v.NPC.Coords.z)  -- BlipAddForCoords
            SetBlipSprite(v.BlipHandle, joaat(v.Blip.Sprite))
            Citizen.InvokeNative(0x9CB1A1623062F402, v.BlipHandle, v.Name)    -- SetBlipName
        end

        LoadModel(v.NPC.Model)
        v.NPChandle = CreatePed(v.NPC.Model, v.NPC.Coords, false, false, true, true)
        Citizen.InvokeNative(0x283978A15512B2FE, v.NPChandle, true)    -- SetRandomOutfitVariation
        SetModelAsNoLongerNeeded(joaat(v.NPC.Model))
        SetEntityInvincible(v.NPChandle, true)
        FreezeEntityPosition(v.NPChandle, true)
        SetBlockingOfNonTemporaryEvents(v.NPChandle, true)
        SetPedConfigFlag(v.NPChandle, 26, true)  -- PCF_DisableMelee

        if v.NPC.Scenario then
            TaskStartScenarioInPlace(v.NPChandle, joaat(v.NPC.Scenario), 0, true, false, false, false)
        end
    end

    while true do
        local t = 500
        if not data_store then 
            for i, v in pairs(Config.ClothingStores) do
                if GetDistanceBetweenCoords(pcoords, v.NPC.Coords.x, v.NPC.Coords.y, v.NPC.Coords.z, false) < 2 then
                    t = 4

                    local label  = CreateVarString(10, 'LITERAL_STRING', v.Name)
                    PromptSetActiveGroupThisFrame(StorePrompts, label)
                    if PromptHasHoldModeCompleted(StorePrompt) then
                        data_store = v
                        VORPcore.instancePlayers(tonumber(GetPlayerServerId(PlayerId()))+ 54123)
                        ClearPedTasksImmediately(v.NPChandle)
                        FreezeEntityPosition(v.NPChandle, false)
                        
                        NetworkSetInSpectatorMode(true, PlayerPedId())
                        DisplayRadar(false)
                        -- DisplayHud(false)
                        TriggerEvent('vorp:showUi', false)

                        TaskGoToCoordAnyMeans(v.NPChandle, v.Coords.Room.x, v.Coords.Room.y, v.Coords.Room.z, 1.0, 0, false, 0, 0.0)
                        Wait(1500)
                        TaskGoToCoordAnyMeans(PlayerPedId(), v.Coords.Room.x, v.Coords.Room.y, v.Coords.Room.z, 1.0, 0, false, 0, 0.0)

                        while true do
                            if GetDistanceBetweenCoords(pcoords, v.Coords.Room.x, v.Coords.Room.y, v.Coords.Room.z, false) < 3 then
                                break
                            end

                            Wait(0)
                        end

                        DoScreenFadeOut(1500)
                        Wait(1500)

                        ClearPedTasks(PlayerPedId())
                        NetworkSetInSpectatorMode(false, PlayerPedId())
                        DoScreenFadeIn(1000)

                        Citizen.InvokeNative(0x203BEFFDBE12E96A, PlayerPedId(), v.Coords.Room, false, false, false)  -- SetEntityCoordsAndHeading
                        ClearPedTasksImmediately(PlayerPedId())
                        TaskStandStill(PlayerPedId(), -1)
                        SetEntityInvincible(PlayerPedId(), true)

                        local HasZ, z = GetGroundZAndNormalFor_3dCoord(v.Coords.Cam.x, v.Coords.Cam.y, v.Coords.Cam.z + 0.5)
                        Cam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', v.Coords.Cam.x, v.Coords.Cam.y, z + 1.5, 0.0, 0.0, v.Coords.Cam.w, 65.00, false, 0)
                        SetCamActive(Cam, true)
                        RenderScriptCams(true, true, 0, 1, 0)

                        Citizen.InvokeNative(0x203BEFFDBE12E96A, v.NPChandle, v.NPC.Coords, false, false, false)  -- SetEntityCoordsAndHeading 
                        ClearPedTasksImmediately(v.NPChandle)
                        FreezeEntityPosition(v.NPChandle, true)
                        
                        if v.NPC.Scenario then
                            TaskStartScenarioInPlace(v.NPChandle, joaat(v.NPC.Scenario), 0, true, false, false, false)
                        end

                        TriggerServerEvent('xakra_clothingstores:OpenClothingStore')
                    end
                end
            end
        end

        Wait(t)
    end
end)

RegisterNetEvent('xakra_clothingstores:OpenClothingStore')
AddEventHandler('xakra_clothingstores:OpenClothingStore', function(Comps, Skin, Outfits)
	Character = {}
    Character.Comps = Comps
    Character.Skin = Skin
    Character.Outfits = Outfits

    for _, Outfits in pairs(Character.Outfits) do
        Outfits.comps = json.decode(Outfits.comps)
    end

    ClothingStoreMenu()
end)


local CameraPrompt, RotatePrompt, ZoomPrompt
local RoomPrompts = GetRandomIntInRange(0, 0xffffff)

Citizen.CreateThread(function()
	local str = _U('CameraPrompt')
	CameraPrompt = PromptRegisterBegin()
	PromptSetControlAction(CameraPrompt, Config.CameraWS[1])
	PromptSetControlAction(CameraPrompt, Config.CameraWS[2])
	str = CreateVarString(10, 'LITERAL_STRING', str)
	PromptSetText(CameraPrompt, str)
	PromptSetEnabled(CameraPrompt, true)
	PromptSetVisible(CameraPrompt, true)
	PromptSetStandardMode(CameraPrompt, 1)
	PromptSetGroup(CameraPrompt, RoomPrompts)
	PromptRegisterEnd(CameraPrompt)

	str = _U('RotatePrompt')
	RotatePrompt = PromptRegisterBegin()
	PromptSetControlAction(RotatePrompt, Config.Rotate[1])
	PromptSetControlAction(RotatePrompt, Config.Rotate[2])
	str = CreateVarString(10, 'LITERAL_STRING', str)
	PromptSetText(RotatePrompt, str)
	PromptSetEnabled(RotatePrompt, true)
	PromptSetVisible(RotatePrompt, true)
	PromptSetStandardMode(RotatePrompt, 1)
	PromptSetGroup(RotatePrompt, RoomPrompts)
	PromptRegisterEnd(RotatePrompt)

	str = _U('ZoomPrompt')
	ZoomPrompt = PromptRegisterBegin()
	PromptSetControlAction(ZoomPrompt, Config.Zoom[1])
	PromptSetControlAction(ZoomPrompt, Config.Zoom[2])
	str = CreateVarString(10, 'LITERAL_STRING', str)
	PromptSetText(ZoomPrompt, str)
	PromptSetEnabled(ZoomPrompt, true)
	PromptSetVisible(ZoomPrompt, true)
	PromptSetStandardMode(ZoomPrompt, 1)
	PromptSetGroup(ZoomPrompt, RoomPrompts)
	PromptRegisterEnd(ZoomPrompt)
end)

Citizen.CreateThread(function()
    while true do
        local t = 500

        if data_store and DoesCamExist(Cam) then
            t = 4

            DrawLightWithRange(data_store.Coords.Cam.x, data_store.Coords.Cam.y, data_store.Coords.Cam.z, 255, 255, 255, 10.0, 100.0)

            local label = CreateVarString(10, 'LITERAL_STRING', data_store.Name..(data_store.Label or ''))
            PromptSetActiveGroupThisFrame(RoomPrompts, label)

            if IsControlPressed(0, Config.CameraWS[1]) then
                local CamCoords = GetCamCoord(Cam)
                local z = math.min(CamCoords.z + 0.01, data_store.Coords.Cam.z + 1)
                SetCamCoord(Cam, data_store.Coords.Cam.x, data_store.Coords.Cam.y, z)
            end
            
            if IsControlPressed(0, Config.CameraWS[2]) then
                local CamCoords = GetCamCoord(Cam)
                local HasZ, PosZ = GetGroundZAndNormalFor_3dCoord(data_store.Coords.Cam.x, data_store.Coords.Cam.y, data_store.Coords.Cam.z + 0.5)
                local z = math.max(CamCoords.z - 0.01, PosZ + 0.2)
                SetCamCoord(Cam, data_store.Coords.Cam.x, data_store.Coords.Cam.y, z)
            end

            if IsControlPressed(0, Config.Rotate[1]) then
                local heading = GetEntityHeading(PlayerPedId())
                SetPedDesiredHeading(PlayerPedId(), heading - 40)
            end

            if IsControlPressed(0, Config.Rotate[2]) then
                local heading = GetEntityHeading(PlayerPedId())
                SetPedDesiredHeading(PlayerPedId(), heading + 40)
            end

            if IsControlPressed(0, Config.Zoom[1]) then
                SetCamFov(Cam, GetCamFov(Cam) - 1.5)
            end

            if IsControlPressed(0, Config.Zoom[2]) then
                SetCamFov(Cam, GetCamFov(Cam) + 1.5)
            end
        end

        Wait(t)
    end
end)

--########################## CLOTHING STORES MENU ##########################
local VORPMenu = {}

TriggerEvent('vorp_menu:getData',function(cb)
    VORPMenu = cb
end)

function ClothingStoreMenu()
    VORPMenu.CloseAll()

    data_store.Label = nil
    data_store.Price = 0

	PrepareMusicEvent('MP_CHARACTER_CREATION_START')
	TriggerMusicEvent('MP_CHARACTER_CREATION_START')
   
    local Elements = {
        { 
            label = _U('Store'),
            value = 'Store',
            -- desc = ''
        }, 
        { 
            label = _U('Outfits'),
            value = 'Outfits',
            -- desc = '',
        },
    }
    
    VORPMenu.Open('default', GetCurrentResourceName(), 'vorp_menu',
        {           
            title = data_store.Name,
            subtext = _U('SubText'),
            align = Config.MenuAlign, 
            elements = Elements,
        },
        function(data, menu)

            if data.current.value == 'Store' then
                StoreMenu()
            end
   
            if data.current.value == 'Outfits' then
                OutfitsClothingStoreMenu()
            end
   
        end, function(data,menu)
            menu.close()
            DoScreenFadeOut(1500)
            Wait(1500)
            CloseClothingStore()
        end
    )
end

--########################## CLOSE CLOTHING STORE ##########################
function CloseClothingStore()
    data_store = nil
    Character = nil

    TriggerMusicEvent('MC_MUSIC_STOP')

    VORPcore.instancePlayers(0)

    SetEntityInvincible(PlayerPedId(), false)
    ClearPedTasks(PlayerPedId())
    FreezeEntityPosition(PlayerPedId(), false)

    NetworkSetInSpectatorMode(false, PlayerPedId())
    DisplayRadar(true)
    -- DisplayHud(true)
    TriggerEvent('vorp:showUi', true)

    DoScreenFadeIn(1500)

    if DoesCamExist(Cam) then
        DestroyCam(Cam)
    end
end

--########################## STORE MENU ##########################
function StoreMenu()
    VORPMenu.CloseAll()

    data_store.Buy = {}

    data_store.Label = nil
    data_store.Price = 0

    data_store.BuyComps = {}

    for i, v in pairs(Character.Comps) do
        data_store.BuyComps[i] = v
    end

    data_store.BuySkin = {}

    for i, v in pairs(Character.Skin) do
        data_store.BuySkin[i] = v
    end

    FaceOverlay('shadows', data_store.BuySkin.shadows_visibility, 1, 1, 0, 0, 1.0, 0, 1, data_store.BuySkin.shadows_palette_color_primary,
    data_store.BuySkin.shadows_palette_color_secondary, data_store.BuySkin.shadows_palette_color_tertiary, data_store.BuySkin.shadows_palette_id, data_store.BuySkin.shadows_opacity)
    FaceOverlay('eyebrows', data_store.BuySkin.eyebrows_visibility, data_store.BuySkin.eyebrows_tx_id, 1, 0, 0, 1.0, 0, 1, data_store.BuySkin.eyebrows_color, 0, 0, 1, data_store.BuySkin.eyebrows_opacity)
    FaceOverlay('eyeliners', data_store.BuySkin.eyeliner_visibility, 1, 1, 0, 0, 1.0, 0, 1, data_store.BuySkin.eyeliner_color_primary, 0, 0, data_store.BuySkin.eyeliner_tx_id, data_store.BuySkin.eyeliner_opacity)
    FaceOverlay('blush', data_store.BuySkin.blush_visibility, data_store.BuySkin.blush_tx_id, 1, 0, 0, 1.0, 0, 1, data_store.BuySkin.blush_palette_color_primary, 0, 0, 1, data_store.BuySkin.blush_opacity)
    FaceOverlay('lipsticks', data_store.BuySkin.lipsticks_visibility, 1, 1, 0, 0, 1.0, 0, 1, data_store.BuySkin.lipsticks_palette_color_primary,
    data_store.BuySkin.lipsticks_palette_color_secondary, data_store.BuySkin.lipsticks_palette_color_tertiary, data_store.BuySkin.lipsticks_palette_id, data_store.BuySkin.lipsticks_opacity)


    local Elements = {
        {
			label = _U('Clothes'),
			value = 'Clothes',
		},
        {
			label = _U('Makeup'),
			value = 'Makeup',
		},
	}

    VORPMenu.Open('default', GetCurrentResourceName(), 'vorp_menu',
        {           
            title = data_store.Name,
            subtext = _U('SubText'),
            align = Config.MenuAlign, 
            elements = Elements,
            lastmenu = 'ClothingStoreMenu',
        },
        function(data, menu)
            if data.current == 'backup' then
                _G[data.trigger]()
            end

            if data.current.value == 'Makeup' then
				MakeupMenu()
            end

            if data.current.value == 'Clothes' then
				ClothesMenu(data.current.value, data.current.id)
            end

        end, function(data,menu)
        end
    )
end

RegisterNetEvent('xakra_clothingstores:CloseClothingStore')
AddEventHandler('xakra_clothingstores:CloseClothingStore', function()
    VORPMenu.CloseAll()
    DoScreenFadeOut(1500)
    Wait(1500)
    CloseClothingStore()
end)

--########################## CLOTHES MENU ##########################
function ClothesMenu()
    VORPMenu.CloseAll()

    data_store.Label = ' - ~t6~'..data_store.Price..'$'

    local Elements = {}

    if IsPedMale(PlayerPedId()) then
        for i, v in pairs(Clothes.Male) do
            Elements[#Elements + 1] = {
                label = _U(i),
                Clothes = v,
                Category = i,
            }
        end

    else
        for i, v in pairs(Clothes.Female) do
            Elements[#Elements + 1] = {
                label = _U(i),
                Clothes = v,
                Category = i,
            }
        end
    end

    Elements[#Elements + 1] = {
        label = _U('Buy'),
        value = 'Buy',
    }
    
    VORPMenu.Open('default', GetCurrentResourceName(), 'vorp_menu',
        {           
            title = data_store.Name,
            subtext = _U('SubText'),
            align = Config.MenuAlign, 
            elements = Elements,
            lastmenu = 'StoreMenu',
        },
        function(data, menu)
            if data.current == 'backup' then
                _G[data.trigger]()
                SetOutfit(Character.Comps)
            end

            if data.current.Clothes then
				ClothMenu(data.current)
            end

            if data.current.value == 'Buy' then
                local Input = {
                    type = 'enableinput',
                    inputType = 'input',
                    button = _U('Confirm'),
                    placeholder = _U('PaceHolder'),
                    style = 'block',
                    attributes = {
                        inputHeader = _U('Header'),
                        type = 'text',
                        pattern = '[A-Za-z]{2,20}',
                        title = data_store.Name,
                        style = 'border-radius: 10px; background-color: ; border:none;'
                    }
                }
                TriggerEvent('vorpinputs:advancedInput', json.encode(Input), function(result)
                    local Name = tostring(result)
                    TriggerServerEvent('xakra_clothingstores:BuyClothes', data_store.Price, data_store.BuyComps, Name)
                end)	
            end
   
        end, function(data,menu)
        end
    )
end

function ClothMenu(CategoryData)
    VORPMenu.CloseAll()

    local Elements = {
        {
            label = CategoryData.label,
            type = 'slider',
            value = 0,
            min = 0,
            max = #CategoryData.Clothes,
            IsCateogry = true,
            -- desc = '',
        },
    }

    if data_store.BuyComps[CategoryData.Category] ~= -1 then
        for index, Clothes in pairs(CategoryData.Clothes) do
            for i, v in pairs(Clothes) do
                if data_store.BuyComps[CategoryData.Category] == v.hash then
                    Elements[1].value = index

                    Elements[#Elements + 1] = {
                        label = _U('Color'),
                        type = 'slider',
                        value = i,
                        min = 1,
                        max = #Clothes,
                        Index = index,
                        -- desc = '',
                    }
                    break
                end
            end
        end
    end

    VORPMenu.Open('default', GetCurrentResourceName(), 'vorp_menu',
        {           
            title = data_store.Name,
            subtext = _U('SubText'),
            align = Config.MenuAlign, 
            elements = Elements,
            lastmenu = 'ClothesMenu',
        },
        function(data, menu)
            if data.current == 'backup' then
                _G[data.trigger]()
            end

            if data.current.type == 'slider' and data.current.value < 1 then
                local Elements1 = {
                    {
                        label = CategoryData.label,
                        type = 'slider',
                        value = 0,
                        min = 0,
                        max = #CategoryData.Clothes,
                        IsCateogry = true,
                        -- desc = '',
                    },
                }

                menu.setElements(Elements1)
                menu.refresh()

                RemoveTagFromMetaPed(CategoryData.Category)
                data_store.BuyComps[CategoryData.Category] = -1

                if data_store.Buy[CategoryData.Category] then
                    data_store.Buy[CategoryData.Category] = nil
                    data_store.Price = data_store.Price - Config.Prices[CategoryData.Category]
                    data_store.Label = ' - ~t6~'..data_store.Price..'$'
                end
            end

            if data.current.type == 'slider' and data.current.value > 0 and not data.current.IsCateogry then
                ApplyShopItemToPed(CategoryData.Clothes[data.current.Index][data.current.value].hash, CategoryData.Category)
                data_store.BuyComps[CategoryData.Category] = CategoryData.Clothes[data.current.Index][data.current.value].hash
                
                if not data_store.Buy[CategoryData.Category] then
                    data_store.Buy[CategoryData.Category] = true
                    data_store.Price = data_store.Price + Config.Prices[CategoryData.Category]
                    data_store.Label = ' - ~t6~'..data_store.Price..'$'
                end
            end

            if data.current.type == 'slider' and data.current.value > 0 and data.current.IsCateogry then
                local Elements1 = {}

                Elements1[#Elements1 + 1] = {
                    label = CategoryData.label,
                    type = 'slider',
                    value = data.current.value,
                    min = 0,
                    max = #CategoryData.Clothes,
                    IsCateogry = true,
                    -- desc = '',
                }

                Elements1[#Elements1 + 1] = {
                    label = _U('Color'),
                    type = 'slider',
                    value = 1,
                    min = 1,
                    max = #CategoryData.Clothes[data.current.value],
                    Index = data.current.value,
                    -- desc = '',
                }

                menu.setElements(Elements1)
                menu.refresh()

                ApplyShopItemToPed(CategoryData.Clothes[data.current.value][1].hash, CategoryData.Category)
                data_store.BuyComps[CategoryData.Category] = CategoryData.Clothes[data.current.value][1].hash

                if not data_store.Buy[CategoryData.Category] then
                    data_store.Buy[CategoryData.Category] = true
                    data_store.Price = data_store.Price + Config.Prices[CategoryData.Category]
                    data_store.Label = ' - ~t6~'..data_store.Price..'$'
                end
            end
   
   
        end, function(data,menu)
        end
    )
end

--########################## MAKEUP MENU ##########################
function MakeupMenu()
    VORPMenu.CloseAll()

    data_store.Label = ' - ~t6~'..data_store.Price..'$'

    local Elements = {}

	for i, v in pairs(Makeup) do
        if overlayLookup[i] then
            -- *texture
            Elements[#Elements + 1] = {
                label = overlayLookup[i].label..' '.._U('Texture'),
                value = data_store.BuySkin[overlayLookup[i].txt_id] or 0,
                min = 0,
                max = #v,
                type = 'slider',
                txt_id = overlayLookup[i].txt_id,
                opac = overlayLookup[i].opacity,
                color = overlayLookup[i].color,
                variant = overlayLookup[i].variant,
                visibility = overlayLookup[i].visibility,
                -- desc = '',
                name = i,
                tag = 'texture'
            }

            -- *Color
            local ColorValue = 0
            for x, color in pairs(color_palettes[i]) do
                if joaat(color) == data_store.BuySkin[overlayLookup[i].color] then
                    ColorValue = x
                end
            end
    
            Elements[#Elements + 1] = {
                label = overlayLookup[i].label..' '.._U('Color'),
                value = ColorValue,
                min = 0,
                max = 10,
                comp = color_palettes[i],
                type = 'slider',
                txt_id = overlayLookup[i].txt_id,
                opac = overlayLookup[i].opacity,
                color = overlayLookup[i].color,
                visibility = overlayLookup[i].visibility,
                variant = overlayLookup[i].variant,
                -- desc = '',
                name = i,
                tag = 'color'
            }

            if i == 'lipsticks' then
                local Color2Value = 0
                for x, color in pairs(color_palettes[i]) do
                    if joaat(color) == data_store.BuySkin[overlayLookup[i].color2] then
                        Color2Value = x
                    end
                end

                --*Color 2
                Elements[#Elements + 1] = {
                    label = overlayLookup[i].label..' '.._U('SecondaryColor'),
                    value = Color2Value,
                    min = 0,
                    max = 10,
                    type = 'slider',
                    comp = color_palettes[i],
                    txt_id = overlayLookup[i].txt_id,
                    opac = overlayLookup[i].opacity,
                    color = overlayLookup[i].color,
                    color2 = overlayLookup[i].color2,
                    color3 = overlayLookup[i].color3,
                    variant = overlayLookup[i].variant,
                    visibility = overlayLookup[i].visibility,
                    -- desc = '',
                    name = i,
                    tag = 'color2'
                }
            end

            if i == 'lipsticks' or i == 'shadows' or i == 'eyeliners' then
                --*Variant
                Elements[#Elements + 1] = {
                    label = overlayLookup[i].label..' '.._U('Variant'),
                    value = data_store.BuySkin[overlayLookup[i].variant],
                    min = 0,
                    max = overlayLookup[i].varvalue,
                    type = 'slider',
                    comp = color_palettes[i],
                    txt_id = overlayLookup[i].txt_id,
                    opac = overlayLookup[i].opacity,
                    color = overlayLookup[i].color,
                    color2 = overlayLookup[i].color2,
                    color3 = overlayLookup[i].color3,
                    variant = overlayLookup[i].variant,
                    visibility = overlayLookup[i].visibility,
                    -- desc = '',
                    name = i,
                    tag = 'variant'
                }
            end

            --* opacity
            Elements[#Elements + 1] = {
                label = overlayLookup[i].label..' '.._U('Opacity'),
                value = data_store.BuySkin[overlayLookup[i].opacity],
                min = 0,
                max = 0.9,
                hop = 0.1,
                type = 'slider',
                txt_id = overlayLookup[i].txt_id,
                opac = overlayLookup[i].opacity,
                color = overlayLookup[i].color,
                variant = overlayLookup[i].variant,
                visibility = overlayLookup[i].visibility,
                -- desc = '',
                name = i,
                tag = 'opacity'
            }
        end
    end

    Elements[#Elements + 1] = {
        label = _U('Buy'),
        value = 'Buy',
    }
    
    VORPMenu.Open('default', GetCurrentResourceName(), 'vorp_menu',
        {           
            title = data_store.Name,
            subtext = _U('SubText'),
            align = Config.MenuAlign, 
            elements = Elements,
            lastmenu = 'StoreMenu',
        },
        function(data, menu)
            if data.current == 'backup' then
                _G[data.trigger]()
                ExecuteCommand('rc')
            end

            if data.current.tag == 'texture' then
                --* texture id
                if data.current.value < 0 then
                    data_store.BuySkin[data.current.visibility] = 0
                else
                    data_store.BuySkin[data.current.visibility] = 1
                end
                data_store.BuySkin[data.current.txt_id] = data.current.value
                toggleOverlayChange(data.current.name, data_store.BuySkin[data.current.visibility],
                data_store.BuySkin[data.current.txt_id], 1, 0, 0,
                    1.0, 0, 1, data_store.BuySkin[data.current.color], data_store.BuySkin[data.current.color2] or 0,
                    data_store.BuySkin[data.current.color3] or 0, data_store.BuySkin[data.current.variant] or 1,
                    data_store.BuySkin[data.current.opac], data_store.BuySkin.albedo)
            end

            if data.current.tag == 'color' then
                --* color
                data_store.BuySkin[data.current.color] = data.current.comp[data.current.value]
                toggleOverlayChange(data.current.name, data_store.BuySkin[data.current.visibility],
                    data_store.BuySkin[data.current.txt_id], 1, 0, 0,
                    1.0, 0, 1, data_store.BuySkin[data.current.color], data_store.BuySkin[data.current.color2] or 0,
                    data_store.BuySkin[data.current.color3] or 0, data_store.BuySkin[data.current.variant] or 1,
                    data_store.BuySkin[data.current.opac], data_store.BuySkin.albedo)
            end

            if data.current.tag == 'color2' then
                --* color secondary
                data_store.BuySkin[data.current.color2] = data.current.comp[data.current.value]
                toggleOverlayChange(data.current.name, data_store.BuySkin[data.current.visibility],
                    data_store.BuySkin[data.current.txt_id], 1, 0, 0,
                    1.0, 0, 1, data_store.BuySkin[data.current.color], data_store.BuySkin[data.current.color2] or 0,
                    data_store.BuySkin[data.current.color3] or 0, data_store.BuySkin[data.current.variant] or 1, data_store.BuySkin
                    [data.current.opac], data_store.BuySkin.albedo)
            end

            if data.current.tag == 'variant' then
                --* variant
                data_store.BuySkin[data.current.variant] = data.current.value
                toggleOverlayChange(data.current.name, data_store.BuySkin[data.current.visibility], data_store.BuySkin[data.current.txt_id], 1, 0, 0,
                    1.0, 0, 1, data_store.BuySkin[data.current.color], data_store.BuySkin[data.current.color2] or 0,
                    data_store.BuySkin[data.current.color3] or 0, data_store.BuySkin[data.current.variant] or 1,
                    data_store.BuySkin[data.current.opac], data_store.BuySkin.albedo)
            end

            if data.current.tag == 'opacity' then
                --* opacity
                if data.current.value <= 0 then
                    data_store.BuySkin[data.current.visibility] = 0
                else
                    data_store.BuySkin[data.current.visibility] = 1
                end

                data_store.BuySkin[data.current.opac] = data.current.value
                toggleOverlayChange(data.current.name, data_store.BuySkin[data.current.visibility],
                    data_store.BuySkin[data.current.txt_id], 1, 0, 0,
                    1.0, 0, 1, data_store.BuySkin[data.current.color], data_store.BuySkin[data.current.color2] or 0,
                    data_store.BuySkin[data.current.color3] or 0, data_store.BuySkin[data.current.variant] or 1,
                    data_store.BuySkin[data.current.opac], data_store.BuySkin.albedo)
            end

            if Config.Prices[data.current.tag] and not data_store.Buy[data.current.tag] then
                data_store.Buy[data.current.tag] = true
                data_store.Price = data_store.Price + Config.Prices[data.current.tag]
                data_store.Label = ' - ~t6~'..data_store.Price..'$'
            end

            if data.current.value == 'Buy' then
                TriggerServerEvent('xakra_clothingstores:BuyMakeup', data_store.Price, data_store.BuySkin)	
            end
   
        end, function(data,menu)
        end
    )
end


--########################## OUTFITS CLOTHING STORES MENU ##########################
function OutfitsClothingStoreMenu()
    VORPMenu.CloseAll()

    local Elements = {}

	for i, v in pairs(Character.Outfits) do
		local outfitName
		if i == '' then 
            outfitName = 'Outfit' 
        else 
            outfitName = v.title 
        end

		Elements[#Elements + 1] = {
			label = outfitName,
			value = i,
			id = v.id
		}
	end
    
    VORPMenu.Open('default', GetCurrentResourceName(), 'vorp_menu',
        {           
            title = data_store.Name,
            subtext = _U('SubText'),
            align = Config.MenuAlign, 
            elements = Elements,
            lastmenu = 'ClothingStoreMenu',
        },
        function(data, menu)
            if data.current == 'backup' then
                _G[data.trigger]()
            end

            if data.current.value then
				OutfitSubMenu(data.current.value, data.current.id)
            end
   
   
        end, function(data,menu)
        end
    )
end

function OutfitSubMenu(index, id)
    VORPMenu.CloseAll()

    SetOutfit(Character.Outfits[index].comps)

    local Elements = {
		{ 
            label = _U('SelectOutfit'), 
            value = 'SelectOutfit',
        },
		{ 
            label = _U('DeleteOutfit'), 
            value = 'DeleteOutfit' ,
        },
    }
    
    VORPMenu.Open('default', GetCurrentResourceName(), 'vorp_menu',
        {           
            title = data_store.Name,
            subtext = _U('SubText'),
            align = Config.MenuAlign, 
            elements = Elements,
            lastmenu = 'OutfitsClothingStoreMenu',
        },
        function(data, menu)
            if data.current == 'backup' then
                _G[data.trigger]()
				SetOutfit(Character.Comps)
            end

			if data.current.value == 'SelectOutfit' then
				TriggerServerEvent('xakra_clothingstores:SetOutfit', Character.Outfits[index].comps)
                Character.Comps = Character.Outfits[index].comps
                ClothingStoreMenu()

			elseif data.current.value == 'DeleteOutfit' then
                TriggerServerEvent('xakra_clothingstores:DeleteOutfit', id)
                Character.Outfits[index] = nil
                SetOutfit(Character.Comps)
				OutfitsClothingStoreMenu()
			end
   
        end, function(data,menu)
        end
    )
end

function SetOutfit(Comps)
	for _, hash in pairs(ClothingCategories) do
		Citizen.InvokeNative(0xD710A5007C2AC539, PlayerPedId(), hash, 0)  -- RemoveTagFromMetaPed
	end

	for category, value in pairs(Comps) do
		if value ~= -1 then
            Citizen.InvokeNative(0xD3A7B003ED343FD9, PlayerPedId(), value, false, false, false)
			Citizen.InvokeNative(0xD3A7B003ED343FD9, PlayerPedId(), value, true, true, false)
		end
	end
end

--########################## RESOURCE STOP ##########################
AddEventHandler('onResourceStop', function (resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end

    DestroyAllCams(true)
    for i, v in pairs(Config.ClothingStores) do
        if DoesBlipExist(v.BlipHandle) then
            RemoveBlip(v.BlipHandle)
        end
        if DoesEntityExist(v.NPChandle) then
            DeletePed(v.NPChandle)
        end
    end

    VORPMenu.CloseAll()
    CloseClothingStore()
end)