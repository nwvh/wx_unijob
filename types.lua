---@class Blip
---@field location vector3
---@field label string
---@field showForEveryone boolean
---@field sprite number
---@field color number
---@field size number

---@class Vehicle
---@field type string
---@field label string
---@field grade number
---@field model string
---@field trailer? string
---@field extras? table<number, number>
---@field performanceUpgrades? table<string, boolean>
---@field cosmeticUpgrades? table<string, boolean>
---@field livery? number
---@field plate? string|boolean

---@class ShopItem
---@field name string
---@field count number
---@field license string
---@field price number
---@field grade number

---@class ShopLocation
---@field label string
---@field coords table<number, vector3>
---@field minGrade number
---@field items table<number, ShopItem>

---@class CollectingPoint
---@field coords table<number, vector3>
---@field item string
---@field amount number
---@field collectingTime number

---@class SellPointItem
---@field [string] number

---@class SellPoint
---@field coords vector3
---@field npc string
---@field items SellPointItem

---@class Job
---@field jobName string
---@field label string
---@field whitelisted boolean
---@field blips table<number, Blip>
---@field canAccess table<string, boolean>
---@field vehicles table<string, table<number, Vehicle>>
---@field silentAlarm table<string, boolean|table<number, vector3>>
---@field shops table<string, boolean|table<number, ShopLocation>>
---@field collectingPoints table<string, boolean|table<number, CollectingPoint>>
---@field sellPoints table<string, boolean|table<number, SellPoint>>
---@type table<string, Job>
