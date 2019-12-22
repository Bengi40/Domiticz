--[[ 

Type :   device
Name :   Mode ETE / Hiver      
 
Description : Allumer ou eteindre les radiateurs suivant la saison


Usage :    


Version : 2.0

log : Simplification et allegement du code
--]]

----------------------------------------------
------          Configuration          -------
----------------------------------------------

local thermostat		= 'Saison'				--Gestion de la saison
local heure_creuse		= 'heureCreuse'			--Gestion des heures creuses et pleines

-- entrer les nom des radiateurs a la suite
local thermostatRadiateurs={
    "Thermostat SDB", 
    "Thermostat Bureau",
    "Thermostat CH2", 
    "Thermostat CH1", 
    "Thermostat SAM"
}

----------------------------------------------
--       Fin de la partie configuration     --
----------------------------------------------

commandArray = {}

if (devicechanged[thermostat]) then

    if (otherdevices[thermostat]=='Hiver') and (otherdevices[heure_creuse]=='Heure Creuse') then
        for i = 1, #thermostatRadiateurs do
            print('Passage du ' ..thermostatRadiateurs[i].. ' en mode Confort')
            commandArray[thermostatRadiateurs[i]]='Set Level 20'
        end    
        
    elseif (otherdevices[thermostat]=='Hiver') and (otherdevices[heure_creuse]=='Heure Pleine') then
        for i = 1, #thermostatRadiateurs do 
            print('Passage du ' ..thermostatRadiateurs[i].. ' en mode eco')
                commandArray[thermostatRadiateurs[i]]='Set Level 10'
        end
        
    else 
        for i = 1, #thermostatRadiateurs do 
            print('Passage du ' ..thermostatRadiateurs[i].. ' en Off')
		  commandArray[thermostatRadiateurs[i]]='Off'
        end
    end 
end
return commandArray
