Config = {}

-- Required item to use the payphone
Config.RequiredItem = "phone"

-- Time limit to reach the dealer (in minutes)
Config.TimeLimit = 20

-- Notification settings
Config.Notifications = {
    NoItem = "You need a burner phone to use this payphone.",
    PhoneUsed = "You've made contact. Check your GPS for the location.",
    TimerStarted = "You have " .. Config.TimeLimit .. " minutes to reach the location.",
    TimerExpired = "You took too long. The contact is gone.",
    DealerLeaving = "The dealer is leaving in 60 seconds.",
    PurchaseSuccess = "Transaction complete.",
}

-- Payphone prop models
Config.PayphoneModels = {
    `prop_phonebox_01a`,
    `prop_phonebox_01b`,
    `prop_phonebox_01c`,
    `prop_phonebox_02`,
    `prop_phonebox_03`,
    `prop_phonebox_04`,
    `prop_phone_ing`,
    `prop_phone_ing_02`,
    `prop_phone_ing_03`,
    `prop_payphone_01a`,
    `prop_payphone_01b`,
    `prop_payphone_01c`,
    `prop_payphone_02`,
    `prop_payphone_03`,
    `prop_payphone_04`
}

-- Possible dealer spawn locations (25 carefully selected locations)
Config.DealerLocations = {
    -- City locations
    {x = 219.02, y = -919.89, z = 30.69, h = 342.12}, -- Legion Square area
    {x = 122.11, y = -1069.63, z = 29.19, h = 357.23}, -- Near PDM
    {x = -57.26, y = -1212.29, z = 28.66, h = 269.34}, -- Near Maze Bank Arena
    {x = 377.98, y = -990.16, z = 29.41, h = 89.76}, -- Near Mission Row PD (but not too close)
    {x = 808.06, y = -2157.53, z = 29.62, h = 359.12}, -- Industrial area
    {x = 1204.31, y = -1474.66, z = 34.86, h = 90.23}, -- El Burro Heights
    {x = 955.85, y = -2123.13, z = 30.55, h = 85.12}, -- Near airport
    {x = 1090.59, y = -788.96, z = 58.26, h = 179.34}, -- Mirror Park
    {x = 1183.86, y = -330.46, z = 69.17, h = 97.23}, -- Mirror Park hills
    {x = 751.11, y = -558.56, z = 33.48, h = 206.45}, -- La Mesa
    
    -- Suburban locations
    {x = -1543.39, y = -453.20, z = 35.88, h = 231.56}, -- Del Perro
    {x = -1166.83, y = -741.25, z = 19.63, h = 308.78}, -- Vespucci Canals
    {x = -817.71, y = -1079.74, z = 11.13, h = 120.45}, -- Vespucci Beach
    {x = -1392.82, y = -584.96, z = 30.22, h = 35.67}, -- Del Perro Beach
    {x = -1662.58, y = -1080.61, z = 13.15, h = 232.12}, -- Del Perro Pier area
    
    -- Highway and rural locations
    {x = 2555.35, y = 382.18, z = 108.62, h = 175.67}, -- Tataviam Mountains
    {x = 2567.72, y = 1644.90, z = 27.77, h = 263.45}, -- Route 68
    {x = 1551.93, y = 2189.07, z = 78.85, h = 177.23}, -- Grand Senora Desert
    {x = 1991.61, y = 3054.56, z = 47.21, h = 237.89}, -- Sandy Shores outskirts
    {x = 139.54, y = 6608.64, z = 31.84, h = 269.78}, -- Paleto Bay
    
    -- Parking lots (spacious areas)
    {x = 59.79, y = -876.21, z = 30.26, h = 341.23}, -- Legion Square parking
    {x = -330.52, y = -780.24, z = 33.96, h = 229.56}, -- Rockford Hills parking
    {x = 542.97, y = -1903.41, z = 24.99, h = 320.45}, -- La Puerta parking
    {x = -676.71, y = -2458.65, z = 13.94, h = 148.23}, -- LSIA parking
    {x = -1184.93, y = -1510.25, z = 4.36, h = 125.67}, -- Airport Parking
}

-- Dealer ped models
Config.DealerPeds = {
    "g_m_y_lost_01", 
    "g_m_y_mexgoon_01", 
    "g_m_y_salvagoon_01",
    "a_m_y_mexthug_01",
    "g_m_y_korean_01",
    "a_m_m_eastsa_02",
    "a_m_y_eastsa_02",
    "g_m_y_ballasout_01"
}



-- Items available for purchase
Config.BlackMarketItems = {
    {
        name = "cauldron",
        label = "cauldron",
        price = 1500,
        type = "item",
    },
    {
        name = "meth_cooking_table",
        label = "meth cooking table",
        price = 900,
        type = "item",
    },
    {
        name = "mixer",
        label = "mixer",
        price = 1500,
        type = "item",
    },
    {
        name = "meth_oven",
        label = "meth oven",
        price = 1250,
        type = "item",
    },
    {
        name = "coke_oven",
        label = "coke oven",
        price = 3000,
        type = "item",
    },
    {
        name = "press",
        label = "press",
        price = 1500,
        type = "weapon",
    },

}
