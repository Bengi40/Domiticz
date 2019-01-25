dofile('/home/pi/domoticz/scripts/lua/config.lua')
--[[
bibliothèque de fonctions pour domoticz
utiles à la réalisation de scripts d'automation en langage lua
/!\ certaines fonctions ne fonctionneront pas sous windows.
copier ce qui se trouve entre les 2 lignes ci dessous, en début de tout vos script
pour charger ce fichier et pouvoir en utiliser les fonctions
--------------------------------------------------------------------------------------------------------
-- chargement des modules (http://easydomoticz.com/forum/viewtopic.php?f=17&t=3940)
dofile('/home/pi/domoticz/scripts/lua/fonctions.lua')
local debug = true  -- true pour voir les logs dans la console log Dz ou false pour ne pas les voir
--------------------------------------------------------------------------------------------------------
]]


-- chemin vers le dossier lua et curl
if (package.config:sub(1,1) == '/') then
	-- system linux
	luaDir = debug.getinfo(1).source:match("@?(.*/)")
	curl = '/usr/bin/curl -m 15 '		 							-- ne pas oublier l'espace à la fin
else
	-- system windows
	luaDir = string.gsub(debug.getinfo(1).source:match("@?(.*\\)"),'\\','\\\\')
	-- download curl : https://bintray.com/vszakats/generic/download_file?file_path=curl-7.54.0-win32-mingw.7z
	curl = 'c:\\Programs\\Curl\\curl.exe '		 					-- ne pas oublier l'espace à la fin
end

-- chargement du fichier JSON.lua
--json = assert(loadfile(luaDir..'JSON.lua'))()

-- retourne l'heure actuelle ex: "12:45"
heure = string.sub(os.date("%X"), 1, 5)

-- retourne la date ex: "01:01"
date = os.date("%d:%m")

-- retourne l'heure du lever de soleil ex: "06:41"
leverSoleil = string.sub(os.date("!%X",60*timeofday['SunriseInMinutes']), 1, 5)

-- retourne l'heure du coucher de soleil ex: "22:15"
coucherSoleil = string.sub(os.date("!%X",60*timeofday['SunsetInMinutes']), 1, 5)

-- retourne le jour actuel en français ex: "mardi"
days = {"dimanche","lundi","mardi","mercredi","jeudi","vendredi","samedi"}
jour = days[(os.date("%w")+1)]

-- est valide si la semaine est paire
-- usage :
-- if semainePaire then ..
semainePaire = os.date("%W")%2 == 0

-- il fait jour
dayTime = timeofday['Daytime']
-- il fait nuit
nightTime = timeofday['Nighttime']

-- température
function getTemp(device)
	return tonumber(string.sub(otherdevices_svalues[device],1,4))
end

-- detection ouverture/fermeture des portes et fenetres
function etatPorte(porte)
    if (devicechanged[porte['ouverte']]) or  (devicechanged[porte['fermee']]) then
    print('-- Gestion de la porte : ' ..porte['virtuel'] ..' --')
        if (otherdevices[porte['ouverte']]=='On') then
            print('-- '..porte['virtuel'] .. ' est ouverte --')
            commandArray[porte['virtuel']]='Off'
        elseif (otherdevices[porte['fermee']]=='On') then
            print('-- '..porte['virtuel'] .. ' est fermee --')
            commandArray[porte['virtuel']]='On'
        end 
    elseif (devicechanged[porte['casse']]) then
        commandArray[porte['alarme']]='On'
        print('-- '..porte['virtuel'] .. ' est arrachee !!!!!! --')
    end
end

-- Transforme la consigne en numerique
function consigneTemperature(consigne)
    return tonumber(otherdevices_svalues[consigne])
end
        
-- Gestion du chauffage
function etatChauffage(chauffage)
    if (devicechanged[chauffage['sonde']]) or (devicechanged[chauffage['fenetre']]) or (devicechanged[chauffage['consigne']]) or (devicechanged[chauffage['saison']]) or (devicechanged[chauffage['heure_creuse']]) or (devicechanged[chauffage['prog_rad']]) then
        
    local temperature = getTemp(chauffage['sonde'])                         --Temperature relevée dans la piece
    local consigne =  consigneTemperature(chauffage['consigne']) -- Temperature voulu
    local fenetre = tonumber(otherdevices_svalues[fenetre])                 -- Récupération de la valeur de la fenetre
     
    local eco		= consigne                          -- Valeur en HP 
    local confort	= consigne + chauffage['confort']   -- Valeur en HC
    local boost		= consigne + chauffage['boost']     -- Boost de la température temporaire
    
    -- Gestion 
        if (otherdevices[chauffage['thermostat']] ~= 'Off') then
            print('-- Gestion du thermostat pour ' ..chauffage['sonde'] .. '--')
            if (otherdevices[chauffage['thermostat']]=='eco') then
                if (temperature < (eco - chauffage['hysteresis']) ) then
                    print('Allumage du chauffage en heure pleine dans : ' ..chauffage['sonde'])
                    commandArray[chauffage['radiateur']]='Off'

                elseif (temperature > (eco + chauffage['hysteresis'])) then
                    print('Extinction du chauffage en heure pleine dans : ' ..chauffage['sonde'])
                    commandArray[chauffage['radiateur']]='On'
                end

            elseif (otherdevices[chauffage['thermostat']]=='confort') then
                if (temperature < (confort - chauffage['hysteresis']) ) then
                    print('Allumage du chauffage en heure creuse dans : ' ..chauffage['sonde'])
                    commandArray[chauffage['radiateur']]='Off'

                elseif (temperature > (confort + chauffage['hysteresis'])) then
                    print('Extinction du chauffage en heure creuse dans : ' ..chauffage['sonde'])
                    commandArray[chauffage['radiateur']]='On'
                end

            elseif (otherdevices[chauffage['thermostat']]=='boost') then
                if (temperature < (boost -chauffage['hysteresis']) ) then
                    print('Allumage du chauffage en Boost dans : ' ..chauffage['sonde'])
                    commandArray[chauffage['radiateur']]='Off'

                elseif (temperature > (boost + chauffage['hysteresis'])) then
                    print('Extinction du chauffage en Boost dans : ' ..chauffage['sonde'])
                    commandArray[chauffage['radiateur']]='On'
                end
            end

        elseif (otherdevices[chauffage['thermostat']]=='Off') then
            commandArray[chauffage['radiateur']]='On'   
        end         
    end  
end
