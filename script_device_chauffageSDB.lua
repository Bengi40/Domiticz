dofile('/home/pi/domoticz/scripts/lua/fonctions.lua')
--[[ 

Type:          time
Name:          
 
Description:   

Usage:         
             

--]]
 
----------------------------------------------
------          Configuration          -------
----------------------------------------------


local   chauffage={}
            chauffage['sonde']          = 'SDB'        		    --Nom de la sonde de température
			chauffage['saison']         = 'Saison'				--Nom de l'interrupteur virtuel du thermostat
			chauffage['thermostat']     = 'Thermostat SDB'		--Interrupteur général du radiateur
            chauffage['radiateur']      = 'Radiateur SDB'    	--Nom du radiateur à allumer/éteindre
            chauffage['fenetre']        = 'Fenetre SDB'			--Nom du detecteur de la fenetre
            chauffage['heure_creuse']   = 'heureCreuse'			--Interrupteur gérant les heures creuses

            chauffage['consigne']       = 'Consigne SDB'     	--Température de consigne
            chauffage['hysteresis']     = 0.5                   --Valeur seuil pour éviter que le relai ne cesse de commuter dans les 2 sens 
            chauffage['confort']        = 1
            chauffage['boost']          = 2 
----------------------------------------------
--       Fin de la partie configuration     --
----------------------------------------------
 

commandArray = {}
    etatChauffage(chauffage)
return commandArray
