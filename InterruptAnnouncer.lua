-------------------------------------------------
-- Interrupt Announcer for WoW 1.12.1
-------------------------------------------------
-- Currently not intended for pure silences,
-- stuns, etc.
-------------------------------------------------

INTANN = {}

INTANN.Version = {
    ["MAJOR"] = 0,
    ["MINOR"] = 1
}

-------------------------------------------------
-- Constants
-------------------------------------------------

INTANN.channel = "SAY"

INTANN.LeftDelimiter = ">> "

INTANN.RightDelimiter = " <<"

INTANN.ResistAnnouncement = INTANN.LeftDelimiter.."Kick - Resist"

INTANN.HitAnnouncement = INTANN.LeftDelimiter.."Kick"

INTANN.RaidSymbolNames = {}

INTANN.RaidSymbolNames.German = {
	[0] = " : Nichts", -- never actually returned by GetRaidTargetIndex. Returns NIL if no raidtarget is assigned
	[1] = " : Stern",
	[2] = " : Kreis",
	[3] = " : Diamant",
	[4] = " : Dreieck",
	[5] = " : Mond",
	[6] = " : Viereck",
	[7] = " : Kreuz",
	[8] = " : Totenkopf"
}

INTANN.RaidSymbolNames.English = {
	[0] = " : Nothing", -- never actually returned by GetRaidTargetIndex. Returns NIL if no raidtarget is assigned
	[1] = " : Star",
	[2] = " : Circle",
	[3] = " : Diamond",
	[4] = " : Triangle",
	[5] = " : Moon",
	[6] = " : Square",
	[7] = " : Cross",
	[8] = " : Skull"
}

-------------------------------------------------
-- Properties of current player
--   to be made non-abstract once class is determined
--   (also see Classes.lua)
-------------------------------------------------

INTANN.Player = {}

INTANN.Player.Settings = {}

INTANN.Player.Clazz = {}

function INTANN.Player.LoadSettings()
	-- Refactor: Use SavedVarsPerCharacter
	local playerName = UnitName("player")
	local realmName = GetRealmName()
	if INTANN_Settings[playerName.."@"..realmName] then
		INTANN.Player.IsActive = INTANN_Settings[playerName.."@"..realmName].IsActive
		INTANN.Player.Language = INTANN_Settings[playerName.."@"..realmName].Language
	else
		INTANN.Settings.SetActive()
		INTANN.Settings.SetLanguage("English")
	end
end

-------------------------------------------------
-- Utility Functions
-------------------------------------------------

function INTANN.ShowMessage(text)
	if(DEFAULT_CHAT_FRAME) then
		DEFAULT_CHAT_FRAME:AddMessage("InterruptAnnouncer: "..text, 1.0, 1.0, 1.0, 1.0)
	end
end

function INTANN.AnnounceState()
	if not INTANN.Player.HasInterrupt then
		INTANN.ShowMessage("No supported interrupts for your class. ACTIVE and INACTIVE mean the same for this class.")
		return
	end
	
	if INTANN.Player.IsActive then
		INTANN.ShowMessage("currently ACTIVE.")
	else
		INTANN.ShowMessage("currently INACTIVE.")
	end
end

INTANN.Settings = {}

function INTANN.Settings.SetActive()
	INTANN.Settings.SetIsActive(true)
end

function INTANN.Settings.SetInactive()
	INTANN.Settings.SetIsActive(false)
end

function INTANN.Settings.SetIsActive(newState)
	INTANN.Player.IsActive = newState
	
	local playerName = UnitName("player")
	local realmName = GetRealmName()
	if not INTANN_Settings[playerName.."@"..realmName] then
		INTANN_Settings[playerName.."@"..realmName] =  {}
	end
	INTANN_Settings[playerName.."@"..realmName].IsActive = newState
end

function INTANN.Settings.SetLanguage(newLanguage)
	INTANN.Player.Language = newLanguage
	
	local playerName = UnitName("player")
	local realmName = GetRealmName()
	if not INTANN_Settings[playerName.."@"..realmName] then
		INTANN_Settings[playerName.."@"..realmName] =  {}
	end
	INTANN_Settings[playerName.."@"..realmName].Language = newLanguage
end

-------------------------------------------------
-- Event Handling
-------------------------------------------------

INTANN.HandleEvent = {}

INTANN.HandleEvent["VARIABLES_LOADED"] = function(arg1)
	if not INTANN_Settings then -- set default settings if loaded for the first time
		INTANN_Settings = {}
		INTANN.Settings.SetActive()
		INTANN.Settings.SetLanguage("English")
		INTANN.ShowMessage("INTANN_Settings was not set. Set to default value ACTIVE.")
	else
		INTANN.ShowMessage("Successfully loaded INTANN_Settings.")
	end
	INTANN.Player.LoadPlayerProperties()
	INTANN.AnnounceState()
	
	InterruptAnnouncerFrame:UnregisterEvent("VARIABLES_LOADED") -- no need to listen to this event anymore
	
	INTANN.RegisterIfNeeded()
end

INTANN.HandleEvent["CHAT_MSG_SPELL_SELF_DAMAGE"] = function(arg1)
	INTANN.EventHandlingPrototypes.HandleDamagingInterrupt(arg1)
end

function INTANN.OnEvent(event, arg1)
    INTANN.HandleEvent[event](arg1)
end

function INTANN.OnLoad()
	-- register variable loading event only. We will conditionally register any other required events once this occurs
	InterruptAnnouncerFrame:RegisterEvent("VARIABLES_LOADED")
end

-------------------------------------------------
-- Prototypes of methods for finding interrupts
-------------------------------------------------

INTANN.EventHandlingPrototypes = {}

-- should be called for pummel, kick, shield bash
function INTANN.EventHandlingPrototypes.HandleDamagingInterrupt(arg1)
	for _,interruptName in INTANN.Player.InterruptNames do
		if string.find(arg1, interruptName) then -- is it the interupt we are looking for?
		
			--find raidtarget and set appropriate text
			local raidtargetindex = GetRaidTargetIndex("target")
			local raidtargettext = ""
			if raidtargetindex then
				raidtargettext = INTANN.RaidSymbolNames[INTANN.Player.Language][raidtargetindex]
			end
			
			-- determine whether to display a success message or a miss message
			local success = string.find(arg1, "hit") or string.find(arg1, "crit") or string.find(arg1, "absorb") -- did it hit?
			if not success then -- supposedly missed, parried or dodged
				SendChatMessage(INTANN.ResistAnnouncement .. raidtargettext .. INTANN.RightDelimiter, INTANN.channel)
			else -- successfully hit
				SendChatMessage(INTANN.HitAnnouncement .. raidtargettext .. INTANN.RightDelimiter, INTANN.channel)
			end
		end
	end
end

-- for counter spell, felhunter spell lock ? or are these also part of CHAT_MSG_SPELL_SELF_DAMAGE?mess
function INTANN.EventHandlingPrototypes.HandleNonDamagingInterrupt(arg1)

end

-------------------------------------------------
-- Event Registering and Unregistering
-------------------------------------------------

function INTANN.RegisterIfNeeded()
	if INTANN.Player.IsActive and INTANN.Player.HasInterrupt then
		InterruptAnnouncerFrame:RegisterEvent(INTANN.Player.EventType)
	end
end

function INTANN.UnregisterIfNeeded()
	if not INTANN.Player.IsActive and INTANN.Player.HasInterrupt then
		InterruptAnnouncerFrame:UnregisterEvent(INTANN.Player.EventType)
	end
end

-------------------------------------------------
-- Slash Commands
-------------------------------------------------

SLASH_INTERRUPT_ANNOUNCER1 = "/intann"
SLASH_INTERRUPT_ANNOUNCER2 = "/interruptannouncer"

SlashCmdList["INTERRUPT_ANNOUNCER"] = function(msg)
    if string.lower(msg) == "on" then
		INTANN.Settings.SetActive()
		INTANN.RegisterIfNeeded()
		INTANN.ShowMessage("InterruptAnnouncer is now ACTIVE.")
	elseif string.lower(msg) == "off" then
		INTANN.Settings.SetInactive()
		INTANN.UnregisterIfNeeded()
		INTANN.ShowMessage("InterruptAnnouncer is now INACTIVE.")
	elseif string.lower(msg) == "state" or string.lower(msg) == "status" then
		INTANN.AnnounceState()
	elseif string.lower(msg) == "announcement language en" then -- too lazy for regex groups right now, guess this should be improved should we ever desire more than two languages
		INTANN.ShowMessage("Set Announcement Language to ENGLISH")
		INTANN.Settings.SetLanguage("English")
	elseif string.lower(msg) == "announcement language ger" then -- too lazy for regex groups right now, guess this should be improved should we ever desire more than two languages
		INTANN.ShowMessage("Set Announcement Language to GERMAN")
		INTANN.Settings.SetLanguage("German")
	else -- display usage
		INTANN.ShowMessage("Usage: Type '/intann on' or '/intann off' to activate or deactive InterruptAnnouncer, respectively.")
		INTANN.ShowMessage("Usage: Type '/intann state' to find out if InterruptAnnouncer is currently active or inactive.")
		INTANN.ShowMessage("Usage: Type '/intann announcement language X', where X is either 'ger' (for german) or 'en' (for english, this is the default).")
	end
end
