dofile('/home/pi/domoticz/scripts/lua/fonctions.lua')
--[[ 

Type:          time
Name:          
 
Description:   

Usage:         
             

--]]
 
----------------------------------------------
------          Configuration          ------
local   saison = 'Saison'
local   chauffage={}
            chauffage['sonde']          = 'Chambre 1'              --Nom de la sonde de température
            chauffage['saison']         = 'Saison'				--Nom de l'interrupteur virtuel du thermostat
            chauffage['thermostat']     = 'Thermostat CH1'   --Interrupteur général du radiateur
            chauffage['radiateur']      = 'Radiateur Parents'    --Nom du radiateur à allumer/éteindre
            chauffage['fenetre']        = 'Fenetre Parents'		--Nom du detecteur de la fenetre
            chauffage['heure_creuse']   = 'heureCreuse'			--Interrupteur gérant les heures creuses

            chauffage['consigne']       = 'Consigne CH1'     --Température de consigne
            chauffage['hysteresis']     = 0.5                   --Valeur seuil pour éviter que le relai ne cesse de commuter dans les 2 sens 
            chauffage['confort']        = 1
            chauffage['boost']          = 2 
----------------------------------------------
--       Fin de la partie configuration       --
----------------------------------------------

commandArray = {}

if (otherdevices[saison]== 'Hiver') then
    etatChauffage(chauffage)
end
return commandArray
