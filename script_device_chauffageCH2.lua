dofile('/home/pi/domoticz/scripts/lua/fonctions.lua')
--[[ 

Type:          device
Name:          
 
Description:   

Usage:         
             

--]]
 
----------------------------------------------
------          Configuration          -------
----------------------------------------------

local   saison = 'Saison'
local   chauffage={}
            chauffage['sonde']          = 'Chambre 2'             --Nom de la sonde de température
            chauffage['saison']         = 'Saison'				  --Nom de l'interrupteur virtuel du thermostat
            chauffage['thermostat']     = 'Thermostat CH2'        --Interrupteur général du radiateur
            chauffage['radiateur']      = 'Radiateur Sora'        --Nom du radiateur à allumer/éteindre
            chauffage['fenetre']        = 'Fenetre Sora'		  --Nom du detecteur de la fenetre
            chauffage['heure_creuse']   = 'heureCreuse'			  --Interrupteur gérant les heures creuses
            chauffage['consigne']       = 'Consigne CH2'          --Température de consigne
            chauffage['hysteresis']     = 0.5                     --Valeur seuil pour éviter que le relai ne cesse de commuter dans les 2 sens 
            chauffage['confort']        = 1
            chauffage['boost']          = 2    

----------------------------------------------
--       Fin de la partie configuration     --
----------------------------------------------
 
commandArray = {}
    etatChauffage(chauffage)
return commandArray
