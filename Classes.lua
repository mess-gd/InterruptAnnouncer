-------------------------------------------------
-- Warrior
-------------------------------------------------

INTANN.Clazz.WARRIOR = {}

INTANN.Clazz.WARRIOR.HasInterrupt = true

INTANN.Clazz.WARRIOR.EventType = "CHAT_MSG_SPELL_SELF_DAMAGE"

INTANN.Clazz.WARRIOR.InterruptNames = {"Pummel", "Shield Bash"}

-------------------------------------------------
-- Paladin
-------------------------------------------------

INTANN.Clazz.PALADIN = {}

--- for testing purposes with paladin: set to true, which is also why the two properties below this one have non-nil values
INTANN.Clazz.PALADIN.HasInterrupt = false

INTANN.Clazz.PALADIN.EventType = "CHAT_MSG_SPELL_SELF_DAMAGE"

INTANN.Clazz.PALADIN.InterruptNames = {"Judgement"}

-------------------------------------------------
-- Shaman
-------------------------------------------------

INTANN.Clazz.SHAMAN = {}

-- interrupt is part of the damage rotation here, prolly we wanna avoid announcing these ?
INTANN.Clazz.SHAMAN.HasInterrupt = false  

-------------------------------------------------
-- Hunter
-------------------------------------------------

INTANN.Clazz.HUNTER = {}

INTANN.Clazz.HUNTER.HasInterrupt = false  

-------------------------------------------------
-- Rogue
-------------------------------------------------

INTANN.Clazz.ROGUE = {}

INTANN.Clazz.ROGUE.HasInterrupt = true

INTANN.Clazz.ROGUE.EventType = "CHAT_MSG_SPELL_SELF_DAMAGE"

INTANN.Clazz.ROGUE.InterruptNames = {"Kick"} 

-------------------------------------------------
-- Druid
-------------------------------------------------

INTANN.Clazz.DRUID = {}

INTANN.Clazz.DRUID.HasInterrupt = false  

-------------------------------------------------
-- Priest
-------------------------------------------------

INTANN.Clazz.PRIEST = {}

INTANN.Clazz.PRIEST.HasInterrupt = false  

-------------------------------------------------
-- Mage
-------------------------------------------------

INTANN.Clazz.MAGE = {}

INTANN.Clazz.MAGE.HasInterrupt = false

-- which event types fire when counterspell / spell lock hits? 

-------------------------------------------------
-- Warlock
-------------------------------------------------

INTANN.Clazz.WARLOCK = {}

INTANN.Clazz.WARLOCK.HasInterrupt = false

-- which event types fire when counterspell / spell lock hits? 