Config = {}

Config.defaultlang = 'es'

Config.MenuAlign = 'top-left'   -- top-right , top-center , top-left

Config.KeyOpenClothingStore = 0xA1ABB953    -- G
Config.prompt_select = 0xC7B5340A   -- NUM ENTER
Config.CameraWS = { 0x8FD015D8, 0xD27782E3 }    -- W and S
Config.Rotate = { 0x7065027D, 0xB4E465B4 }  -- A and D
Config.Zoom = { 0x62800C92, 0x8BDE7443 }    -- MOUSE SCROLL UP and MOUSE SCROLL DOWN

Config.ClothingStores = {
    {
        Name = 'Tienda de ropa de Blackwater',  -- Clothing store name
        Blip = { 
            Enable = true, -- true or false (enable or disable blip)
            Sprite = 'blip_shop_tailor',    -- blip sprite
        },
        NPC = { 
            Model = 'S_M_M_Tailor_01',  -- Clothes shop npc model
            Coords = vector4(-761.57, -1293.54, 42.89, 5.37),   -- vector4 (coordinates of the clothing store npc)
            Scenario = 'WORLD_HUMAN_WAITING_IMPATIENT', -- scenario or false
        },
        Coords = { 
            Room = vector4(-768.02, -1294.97, 42.88, 271.42), -- vector4 (character coordinates in shop preview)
            Cam = vector4(-766.43, -1295.24, 43.9, 85.66),  -- vector4 (camera coordinates)
        },
    },
    {
        Name = 'Tienda de ropa de Valentine',  -- Clothing store name
        Blip = { 
            Enable = true, -- true or false (enable or disable blip)
            Sprite = 'blip_shop_tailor',    -- blip sprite
        },
        NPC = { 
            Model = 'S_M_M_Tailor_01',  -- Clothes shop npc model
            Coords = vector4(-325.54, 772.97, 116.49, 21.15),   -- vector4 (coordinates of the clothing store npc)
            Scenario = 'WORLD_HUMAN_WAITING_IMPATIENT', -- scenario or false
        },
        Coords = { 
            Room = vector4(-329.78, 775.2, 120.68, 269.78), -- vector4 (character coordinates in shop preview)
            Cam = vector4(-326.18, 775.33, 121.69, 96.59),  -- vector4 (camera coordinates)
        },
    },
    {
        Name = 'Tienda de ropa de Rhodes',  -- Clothing store name
        Blip = { 
            Enable = true, -- true or false (enable or disable blip)
            Sprite = 'blip_shop_tailor',    -- blip sprite
        },
        NPC = { 
            Model = 'S_M_M_Tailor_01',  -- Clothes shop npc model
            Coords = vector4(1326.3, -1289.39, 76.07, 202.5),   -- vector4 (coordinates of the clothing store npc)
            Scenario = 'WORLD_HUMAN_WAITING_IMPATIENT', -- scenario or false
        },
        Coords = { 
            Room = vector4(1324.5, -1287.62, 76.07, 157.93), -- vector4 (character coordinates in shop preview)
            Cam = vector4(1322.82, -1289.73, 77.08, 325.64),  -- vector4 (camera coordinates)
        },
    },
    {
        Name = 'Tienda de ropa de Saint Denis',  -- Clothing store name
        Blip = { 
            Enable = true, -- true or false (enable or disable blip)
            Sprite = 'blip_shop_tailor',    -- blip sprite
        },
        NPC = { 
            Model = 'S_M_M_Tailor_01',  -- Clothes shop npc model
            Coords = vector4(2554.77, -1166.81, 52.73, 181.4),   -- vector4 (coordinates of the clothing store npc)
            Scenario = 'WORLD_HUMAN_WAITING_IMPATIENT', -- scenario or false
        },
        Coords = { 
            Room = vector4(2555.76, -1161.43, 52.75, 345.15), -- vector4 (character coordinates in shop preview)
            Cam = vector4(2557.34, -1159.28, 53.75, 145.88),  -- vector4 (camera coordinates)
        },
    },
    {
        Name = 'Tienda de ropa de Van Horn',  -- Clothing store name
        Blip = { 
            Enable = true, -- true or false (enable or disable blip)
            Sprite = 'blip_shop_tailor',    -- blip sprite
        },
        NPC = { 
            Model = 'S_M_M_Tailor_01',  -- Clothes shop npc model
            Coords = vector4(2943.0, 539.47, 48.55, 2.82),   -- vector4 (coordinates of the clothing store npc)
            Scenario = 'WORLD_HUMAN_WAITING_IMPATIENT', -- scenario or false
        },
        Coords = { 
            Room = vector4(2946.41, 542.77, 48.5, 253.2), -- vector4 (character coordinates in shop preview)
            Cam = vector4(2948.61, 542.45, 49.49, 85.0),  -- vector4 (camera coordinates)
        },
    },
    {
        Name = 'Tienda de ropa de Annesburg',  -- Clothing store name
        Blip = { 
            Enable = true, -- true or false (enable or disable blip)
            Sprite = 'blip_shop_tailor',    -- blip sprite
        },
        NPC = { 
            Model = 'S_M_M_Tailor_01',  -- Clothes shop npc model
            Coords = vector4(2945.1, 1336.57, 43.16, 74.82),   -- vector4 (coordinates of the clothing store npc)
            Scenario = 'WORLD_HUMAN_WAITING_IMPATIENT', -- scenario or false
        },
        Coords = { 
            Room = vector4(2945.36, 1331.26, 43.51, 223.86), -- vector4 (character coordinates in shop preview)
            Cam = vector4(2947.0, 1329.17, 44.5, 41.0),  -- vector4 (camera coordinates)
        },
    },
    {
        Name = 'Tienda de ropa de Strawberry',  -- Clothing store name
        Blip = { 
            Enable = true, -- true or false (enable or disable blip)
            Sprite = 'blip_shop_tailor',    -- blip sprite
        },
        NPC = { 
            Model = 'S_M_M_Tailor_01',  -- Clothes shop npc model
            Coords = vector4(-1786.88, -393.48, 159.28, 96.86),   -- vector4 (coordinates of the clothing store npc)
            Scenario = 'WORLD_HUMAN_WAITING_IMPATIENT', -- scenario or false
        },
        Coords = { 
            Room = vector4(-1794.66, -395.55, 159.39, 319.51), -- vector4 (character coordinates in shop preview)
            Cam = vector4(-1793.16, -394.02, 160.39, 141.86),  -- vector4 (camera coordinates)
        },
    },
    {
        Name = 'Tienda de ropa de Armadillo',  -- Clothing store name
        Blip = { 
            Enable = true, -- true or false (enable or disable blip)
            Sprite = 'blip_shop_tailor',    -- blip sprite
        },
        NPC = { 
            Model = 'S_M_M_Tailor_01',  -- Clothes shop npc model
            Coords = vector4(-3685.04, -2628.7, -14.38, 3.78),   -- vector4 (coordinates of the clothing store npc)
            Scenario = 'WORLD_HUMAN_WAITING_IMPATIENT', -- scenario or false
        },
        Coords = { 
            Room = vector4(-3688.53, -2630.52, -14.35, 31.94), -- vector4 (character coordinates in shop preview)
            Cam = vector4(-3689.33, -2628.54, -13.35, 210.42),  -- vector4 (camera coordinates)
        },
    },
    {
        Name = 'Tienda de ropa de Tumbleweed',  -- Clothing store name
        Blip = { 
            Enable = true, -- true or false (enable or disable blip)
            Sprite = 'blip_shop_tailor',    -- blip sprite
        },
        NPC = { 
            Model = 'S_M_M_Tailor_01',  -- Clothes shop npc model
            Coords = vector4(-5519.83, -2975.42, -1.69, 106.27),   -- vector4 (coordinates of the clothing store npc)
            Scenario = 'WORLD_HUMAN_WAITING_IMPATIENT', -- scenario or false
        },
        Coords = { 
            Room = vector4(-5513.68, -2973.43, 1.27, 16.81), -- vector4 (character coordinates in shop preview)
            Cam = vector4(-5514.36, -2971.1, 2.27, 202.38),  -- vector4 (camera coordinates)
        },
    },
}

Config.Prices = {
    -- CLOTHES
    CoatClosed = 25,
    Coat = 28,
    Hat = 12,
    EyeWear = 10,
    Mask = 5,
    NeckWear = 8,
    NeckTies = 10,
    Shirt = 15,
    Suspender = 10,
    Vest = 20,
    Poncho = 18,
    Cloak = 22,
    Glove = 10,
    Belt = 8,
    Pant = 20,
    Boots = 25,
    Spurs = 15,
    Bracelet = 7,
    Buckle = 5,
    Skirt = 15,
    Chap = 20,
    Spats = 12,
    GunbeltAccs = 10,
    Gauntlets = 15,
    Loadouts = 10,
    Accessories = 8,
    Satchels = 12,
    Dress = 20,
    Holster = 15,
    Gunbelt = 10,
    RingRh = 7,
    RingLh = 7,
    Badge = 5,
    Armor = 30,
    HairAccesories = 12,

    -- MAKEUP
    texture = 1,
    color = 1,
    color2 = 1,
    variant = 1,
    opacity = 1, 
}