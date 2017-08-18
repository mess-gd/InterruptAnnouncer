# InterruptAnnouncer
Small utility for WoW 1.12.1 to announce when you trigger an interrupt and / or it misses.

# Classes
Currently, only Rogue and Warrior Interrupts are working. Haven't figured out how to detect the hit / miss of counterspells or warlock spell locks. Feel free to contact me or contribute directly should you know how to detect these.

# Usage
* Channel: Needs to be configured directly in InterruptAnnouncer.lua (for example: replace "SAY" by "YELL")
* Activating / Deactivating: type /intann on to activate the announcements, type /intann off to deactivate them
* Announcement Language: type /intann announcement language ger to switch to german, or /intann announcement language en to switch to english. Other languages currently not supported.
