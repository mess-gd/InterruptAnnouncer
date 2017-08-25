-------------------------------------------------
-- Prototype
-------------------------------------------------

local ClazzPrototype = {}

ClazzPrototype.HasInterrupt = false

ClazzPrototype.EventType = nil

ClazzPrototype.InterruptNames = nil

ClazzPrototype.ResistAnnouncementText = ""

ClazzPrototype.HitAnnouncementText = ""

-------------------------------------------------
-- Warrior
-------------------------------------------------

local Warrior = setmetatable({}, {__index = ClazzPrototype})

Warrior.HasInterrupt = true

Warrior.EventType = "CHAT_MSG_SPELL_SELF_DAMAGE"

Warrior.InterruptNames = {"Pummel", "Shield Bash"}

Warrior.ResistAnnouncementText = "Kick - RESIST"

Warrior.HitAnnouncementText = "Kick"

-------------------------------------------------
-- Paladin
-------------------------------------------------

local Paladin = setmetatable({}, {__index = ClazzPrototype})

--- for testing purposes with paladin: set to true, which is also why the two properties below this one have non-nil values
Paladin.HasInterrupt = true

Paladin.EventType = "CHAT_MSG_SPELL_SELF_DAMAGE"

Paladin.InterruptNames = {"Judgement"}

Paladin.ResistAnnouncementText = "Judgement - RESIST"

Paladin.HitAnnouncementText = "Judgement"

-------------------------------------------------
-- Shaman
-------------------------------------------------

local Shaman = setmetatable({}, {__index = ClazzPrototype})

-------------------------------------------------
-- Hunter
-------------------------------------------------

local Hunter = setmetatable({}, {__index = ClazzPrototype})

-------------------------------------------------
-- Rogue
-------------------------------------------------

local Rogue = setmetatable({}, {__index = ClazzPrototype})

Rogue.HasInterrupt = true

Rogue.EventType = "CHAT_MSG_SPELL_SELF_DAMAGE"

Rogue.InterruptNames = {"Kick"}

Rogue.ResistAnnouncementText = "Kick - RESIST"

Warrior.HitAnnouncementText = "Kick"

-------------------------------------------------
-- Druid
-------------------------------------------------

local Druid = setmetatable({}, {__index = ClazzPrototype})

-------------------------------------------------
-- Priest
-------------------------------------------------

local Priest = setmetatable({}, {__index = ClazzPrototype})

-------------------------------------------------
-- Mage
-------------------------------------------------

local Mage = setmetatable({}, {__index = ClazzPrototype})

-- which event types fire when counterspell / spell lock hits?

-------------------------------------------------
-- Warlock
-------------------------------------------------

local Warlock = setmetatable({}, {__index = ClazzPrototype})

-- which event types fire when counterspell / spell lock hits?

--------------------------------------------------
-- Hook Clazz to global namespace
--------------------------------------------------

local Clazzes = {
    ["WARRIOR"] = Warrior,
    ["PALADIN"] = Paladin,
    ["SHAMAN"] = Shaman,
    ["HUNTER"] = Hunter,
    ["ROGUE"] = Rogue,
    ["DRUID"] = Druid,
    ["PRIEST"] = Priest,
    ["MAGE"] = Mage,
    ["WARLOCK"] = Warlock
}

local hookClazz = function()
    local _, englishClazz = UnitClass("player")
    INTANN.Player.Clazz = Clazzes[englishClazz]
end

hookClazz()