dofile('/home/pi/domoticz/scripts/lua/fonctions.lua')
--[[ 

Type :   device
Name :   Chacon 34946       
 
Description :   Les detecteurs de portes chacon 34946 ne sont pas de type On/Off.
Ils sont representes comme plusieurs modules qui n'ont que le On en reponse.
Il nous faut donc un interuptuer pour l'ouverture, une pour la fermeture et un virtuel qui ferq le lien entre les deux autres
Comme les interupteurs restent sur On, nous allons mettre l'extinction sur 5sec.


Usage :    Lorsque la porte se ferme, le module passe sur On durant 5 secondes. Le script se lance pour passer l'interupteur virtuel sur 'fermer'. Inversement quand la porte s'ouvre
             

Creation de la porte virtuel : mettre en Door Lock

--]]
 
----------------------------------------------
------          Configuration          ------

local porte={}
    porte['ouverte']	= '$Porte Fenetre SAM Gauche ouverte'       -- Nom de l'interupteur d'ouverture
    porte['fermee']	    = '$Porte Fenetre SAM Gauche ferme'         -- Nom de l'interupteur fermeture
    porte['casse']      = '$Porte Fenetre SAM Gauche casse'         -- Nom de l'interupteur en cqs de casse du module
    porte['virtuel']	= 'Porte Fenetre SAM Gauche'               	-- Nom de l'interupteur virtuel
    porte['alarme']     = 'Alarme'                     				-- Nom de l'alarme
----------------------------------------------
--       Fin de la partie configuration     --
----------------------------------------------

commandArray = {}
    etatPorte(porte)
return commandArray
