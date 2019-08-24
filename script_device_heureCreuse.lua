--[[ 

Type:          device
Name:          Gestion Hc/Hp
 
Description:   Régle le thermostat du Radiateur suivant les heures creuse et pleine

Usage:         
             

--]]
 
----------------------------------------------
------          Configuration          -------
----------------------------------------------

local thermostat = {"Thermostat SDB", "Thermostat SAM", "Thermostat Bureau", "Thermostat CH1", "Thermostat CH2"}
local heure_creuse = 'heureCreuse'
local saison = 'Saison'

----------------------------------------------
--       Fin de la partie configuration     --
----------------------------------------------

commandArray = {}
if (otherdevices[saison] == 'Hiver') then
    if (devicechanged[heure_creuse]) then
        for i = 1, #thermostat do 
            if(otherdevices[thermostat]) ~= 'Off' then
                if (otherdevices[heure_creuse]) == 'Heure Creuse' then
                    commandArray[thermostat[i]]= 'Set Level 20'

                elseif (otherdevices[heure_creuse]) == 'Heure Pleine' then
                    commandArray[thermostat[i]]= 'Set Level 10'
				end
            end
		end
    end
end
return commandArray
