dofile('/home/pi/domoticz/scripts/lua/fonctions.lua')


-- script_variable_sms.lua
--
-- un smartphone connecté au réseau wifi de la maison
-- avec l'application 'sms gateway ultimate' installée
-- https://play.google.com/store/apps/details?id=com.icecoldapps.smsgatewayultimate
--
-- dès qu'un sms est reçu, l'application met à jour une variable utilisateur nommée 'sms' via la requette json suivante
-- http://USER:PASS@IP:PORT/json.htm?type=command&param=updateuservariable&idx=IDX&vname=sms&vtype=2&vvalue=%body%;%from%
--
-- dès que la variable 'sms' est modifiée, ce script est exécuté.
-- suivant une correspondance avec l'un des messages de la liste ci dessous,
-- si la personne y est autorisée,
-- l'action associée est lancée
--
-- un message de réponse est retourné
--
-- la commande 'Help' retourne un SMS contenant la liste
--

-------------------------------- 
------ Tableau à éditer ------
--------------------------------

-- liste des messages à comprendre et leurs actions associées
local liste={}
--liste['message'] = "action"
liste['Help'] =             [[   reponse = sendAll()   ]]   -- ne pas toucher cette ligne

-- consultation des status des modules
liste['temp'] =             [[   reponse =    'Salon : '..string.sub(otherdevices_svalues['SAM'],1,4)..'°C'..'\n'..
                                 'Chambre : '..string.sub(otherdevices_svalues['chambre 1'],1,4)..'°C'..'\n'..
                                 'Salle de bain : '..string.sub(otherdevices_svalues['SDB'],1,4)..'°C'   ]]

liste['temp sam'] =         [[   reponse = 'Il fait '..string.sub(otherdevices_svalues['SAM'],1,4)..'°C dans la Salle a manger'   ]]
liste['temp ch1'] =         [[   reponse = 'Il fait '..string.sub(otherdevices_svalues['chambre 1'],1,4)..'°C dans la chambre 1'   ]]
liste['temp ch2'] =         [[   reponse = 'Il fait '..string.sub(otherdevices_svalues['chambre 2'],1,4)..'°C dans la chambre 2'   ]]
liste['temp bureau'] =      [[   reponse = 'Il fait '..string.sub(otherdevices_svalues['Bureau'],1,4)..'°C dans la chambre 2'   ]]
liste['temp sdb'] =         [[   reponse = 'Il fait '..string.sub(otherdevices_svalues['SDB'],1,4)..'°C dans la chambre 2'   ]]

-- Ordre a donner
liste['ete'] =           [[   commandArray['Saison'] = 'Set Level 20'
                                 reponse = 'Je mets le chauffage sur Off'   ]]
liste['hiver'] =           [[   commandArray['Saison'] = 'Set Level 10'
                                 reponse = 'Je mets le chauffage sur On'   ]]
liste['douche'] =           [[   commandArray['RadiateurSDB'] = 'Set Level 30'
                                 reponse = 'Je mets la salle de bain en chauffe'   ]]

liste['volet SAM Off'] =    [[   commandArray['Volet-SAM'] = 'On'
                                 reponse = 'Je ferme le volet de la Salle a manger'   ]]
   

-- liste des utilisateurs autorisés
local user={}
user['benjamin'] = '+33651886111'
user['eloise'] = '+33608956982'
-- etc..      

-- paramètres du serveur SMS Gateway Ultimate   
gateway = smsGatewayIP..':'..smsGatewayPORT     -- url du serveur sms gateway

-- réponses par défaut
local good = 'Ok..'                                 -- réponse en cas de commande correcte
local notGood = 'Je ne comprends pas, essayez \'Help\''      -- réponse en cas de commande non comprise
local guess = 'Je ne vous connais pas !'               -- réponse aux utilisateurs non autorisés

--------------------------------
-- Fin du tableau à éditer --
--------------------------------

function spairs(t)
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = k end
   table.sort(keys)
   local i = 0
   return function()
      i = i + 1
      if keys[i] then
         return keys[i], t[keys[i]]
      end
   end
end

function url_encode(str)
  if (str) then
    str = string.gsub (str, "\n", "\r\n")
    str = string.gsub (str, "([^%w %-%_%.%~])",
        function (c) return string.format ("%%%02X", string.byte(c)) end)
    str = string.gsub (str, " ", "+")
  end
  return str   
end

function sendAll()
   for message, action in spairs(liste) do
      if message ~= 'Help' then
         if rst == nil then
            rst = message
         else
            rst = rst..'\n'..message
         end
      end      
   end
   return rst
end

commandArray = {}

if(uservariablechanged['sms']) then
   sms,from = uservariables['sms']:match("([^;]+);([^;]+)")
   local msg = "print('SMS reçu du N° '..from..' : \"'..sms..'\"')"
   for name, number in pairs(user) do
      reponse = guess
      if number == from then
         print('SMS reçu de '..name..' : \"'..sms..'\"')
         reponse = notGood
         msg = "print('SMS, commande invalide')"
         for message, action in pairs(liste) do
            if sms == message then
               reponse = good
               msg = "print('SMS, commande correcte')"
               load(action)()
               break
            end
         end
         break
      end   
   end
   load(msg)()
   --print('SMS : réponse -> '..reponse)
   --print('SMS : réponse -> '..url_encode(reponse))
   commandArray['OpenURL']=gateway..'/send.html?smsto='..from..'&smsbody='..url_encode(reponse)..'&smstype=sms'
end

return commandArray 