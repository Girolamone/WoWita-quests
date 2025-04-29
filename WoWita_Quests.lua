-- Addon: WoWita_Quests traduttore in italiano
-- Autore: Icedany

-- Variabili locali
local QTR_version = GetAddOnMetadata("WoWita_Quests", "Version");
local QTR_onDebug = false;      
local QTR_name = UnitName("player");
local QTR_class= UnitClass("player");
local QTR_race = UnitRace("player");
local QTR_sex = UnitSex("player"); -- 1:neutro,  2:maschio,  3:femmina
local QTR_waitTable = {};
local QTR_waitFrame = nil;
local QTR_MessOrig = {
      details    = "Description", 
      objectives = "Objectives", 
      rewards    = "Rewards", 
      itemchoose1= "You will be able to choose one of these rewards:", 
      itemchoose2= "Choose one of these rewards:", 
      itemreceiv1= "You will also receive:", 
      itemreceiv2= "You receiving the reward:", 
      learnspell = "Learn Spell:", 
      reqmoney   = "Required Money:", 
      reqitems   = "Required items:", 
      experience = "Experience:", 
      currquests = "Current Quests", 
      avaiquests = "Available Quests", };
local QTR_quest_EN = {
      id = 0,
      title = "",
      details = "",
      objectives = "",
      progress = "",
      completion = "",
      itemchoose = "",
      itemreceive = "", };      
local QTR_quest_LG = {
      id = 0,
      title = "",
      details = "",
      objectives = "",
      progress = "",
      completion = "",
      itemchoose = "",
      itemreceive = "", };
local QTR_Reklama = {
      ON = "Pubblicizza il componente aggiuntivo nel canale di chat n:",
      PERIOD= "Periodo tra annunci successivi:",
      CHOICE= "Quale testo visualizzare? (se si spuntano entrambi, quindi si alternano):",
      OTHER1= "tradurre nell'aggiunta QuestGuru ",
      OTHER2= "tradurre nell'appendice Immersion ",
      OTHER3= "tradurre in trama ",
      ACTIV1= "(attivo)",
      ACTIV2= "(inattivo)",
      WWW1  = "Visita il sito Web del componente aggiuntivo:",
      WWW2  = "",
      WWW3  = "fai clic e premi Ctrl + C per copiare negli appunti",
      TEXT1 = "componente aggiuntivo che visualizza le missioni tradotte ",
      TEXT2 = "un componente aggiuntivo che mostra le missioni in Italiano", };
local last_time = GetTime();
local last_text = 0;
local curr_trans = "1";
local curr_goss = "X";
local curr_hash = 0;
local Original_Font1 = "Fonts\\MORPHEUS.ttf";
local Original_Font2 = "Fonts\\FRIZQT__.ttf";
local p_race = {
  
      ["Blood Elf"] = { M1="Blood Elf", D1="Blood Elf", C1="Blood Elf", B1="Blood Elf", N1="Blood Elf", K1="Blood Elf", W1="Blood Elf", M2="Blood Elf", D2="Blood Elf", C2="Blood Elf", B2="Blood Elf", N2="Blood Elf", K2="Blood Elf", W2="Blood Elf" }, 
      ["Dark Iron Dwarf"] = { M1="Dark Iron Dwarf", D1="Dark Iron Dwarf", C1="Dark Iron Dwarf", B1="Dark Iron Dwarf", N1="Dark Iron Dwarf", K1="Dark Iron Dwarf", W1="Dark Iron Dwarf", M2="Dark Iron Dwarf", D2="Dark Iron Dwarf", C2="Dark Iron Dwarf", B2="Dark Iron Dwarf", N2="Dark Iron Dwarf", K2="Dark Iron Dwarf", W2="Dark Iron Dwarf" },
      ["Draenei"] = { M1="Draenei", D1="Draenei", C1="Draenei", B1="Draenei", N1="Draenei", K1="Draenei", W1="Draenei", M2="Draenei", D2="Draenei", C2="Draenei", B2="Draenei", N2="Draenei", K2="Draenei", W2="Draenei" },
      ["Dwarf"] = { M1="Dwarf", D1="Dwarf", C1="Dwarf", B1="Dwarf", N1="Dwarf", K1="Dwarf", W1="Dwarf", M2="Dwarf", D2="Dwarf", C2="Dwarf", B2="Dwarf", N2="Dwarf", K2="Dwarf", W2="Dwarf" },
      ["Gnome"] = { M1="Gnome", D1="Gnome", C1="Gnome", B1="Gnome", N1="Gnome", K1="Gnome", W1="Gnome", M2="Gnome", D2="Gnome", C2="Gnome", B2="Gnome", N2="Gnome", K2="Gnome", W2="Gnome" },
      ["Goblin"] = { M1="Goblin", D1="Goblin", C1="Goblin", B1="Goblin", N1="Goblin", K1="Goblin", W1="Goblin", M2="Goblin", D2="Goblin", C2="Goblin", B2="Goblin", N2="Goblin", K2="Goblin", W2="Goblin" },
      ["Highmountain Tauren"] = { M1="Highmountain Tauren", D1="Highmountain Tauren", C1="Highmountain Tauren", B1="Highmountain Tauren", N1="Highmountain Tauren", K1="Highmountain Tauren", W1="Highmountain Tauren", M2="Highmountain Tauren", D2="Highmountain Tauren", C2="Highmountain Tauren", B2="Highmountain Tauren", N2="Highmountain Tauren", K2="Highmountain Tauren", W2="Highmountain Tauren" },
      ["Human"] = { M1="Human", D1="Human", C1="Human", B1="Human", N1="Human", K1="Human", W1="Human", M2="Human", D2="Human", C2="Human", B2="Human", N2="Human", K2="Human", W2="Human" },
      ["Kul Tiran"] = { M1="Kul Tiran", D1="Kul Tiran", C1="Kul Tiran", B1="Kul Tiran", N1="Kul Tiran", K1="Kul Tiran", W1="Kul Tiran", M2="Kul Tiran", D2="Kul Tiran", C2="Kul Tiran", B2="Kul Tiran", N2="Kul Tiran", K2="Kul Tiran", W2="Kul Tiran" },
      ["Lightforged Draenei"] = { M1="Lightforged Draenei", D1="Lightforged Draenei", C1="Lightforged Draenei", B1="Lightforged Draenei", N1="Lightforged Draenei", K1="Lightforged Draenei", W1="Lightforged Draenei", M2="Lightforged Draenei", D2="Lightforged Draenei", C2="Lightforged Draenei", B2="Lightforged Draenei", N2="Lightforged Draenei", K2="Lightforged Draenei", W2="Lightforged Draenei" },
      ["Mag'har Orc"] = { M1="Mag'har Orc", D1="Mag'har Orc", C1="Mag'har Orc", B1="Mag'har Orc", N1="Mag'har Orc", K1="Mag'har Orc", W1="Mag'har Orc", M2="Mag'har Orc", D2="Mag'har Orc", C2="Mag'har Orc", B2="Mag'har Orc", N2="Mag'har Orc", K2="Mag'har Orc", W2="Mag'har Orc" },
      ["Nightborne"] = { M1="Nightborne", D1="Nightborne", C1="Nightborne", B1="Nightborne", N1="Nightborne", K1="Nightborne", W1="Nightborne", M2="Nightborne", D2="Nightborne", C2="Nightborne", B2="Nightborne", N2="Nightborne", K2="Nightborne", W2="Nightborne" },
      ["Night Elf"] = { M1="Night Elf", D1="Night Elf", C1="Night Elf", B1="Night Elf", N1="Night Elf", K1="Night Elf", W1="Night Elf", M2="Night Elf", D2="Night Elf", C2="Night Elf", B2="Night Elf", N2="Night Elf", K2="Night Elf", W2="Night Elf" },
      ["Orc"] = { M1="Orc", D1="Orc", C1="Orc", B1="Orc", N1="Orc", K1="Orc", W1="Orc", M2="Orc", D2="Orc", C2="Orc", B2="Orc", N2="Orc", K2="Orc", W2="Orc" },
      ["Pandaren"] = { M1="Pandaren", D1="Pandaren", C1="Pandaren", B1="Pandaren", N1="Pandaren", K1="Pandaren", W1="Pandaren", M2="Pandaren", D2="Pandaren", C2="Pandaren", B2="Pandaren", N2="Pandaren", K2="Pandaren", W2="Pandaren" },
      ["Tauren"] = { M1="Tauren", D1="Tauren", C1="Tauren", B1="Tauren", N1="Tauren", K1="Tauren", W1="Tauren", M2="Tauren", D2="Tauren", C2="Tauren", B2="Tauren", N2="Tauren", K2="Tauren", W2="Tauren" },
      ["Troll"] = { M1="Troll", D1="Troll", C1="Troll", B1="Troll", N1="Troll", K1="Troll", W1="Troll", M2="Troll", D2="Troll", C2="Troll", B2="Troll", N2="Troll", K2="Troll", W2="Troll" },
      ["Undead"] = { M1="Undead", D1="Undead", C1="Undead", B1="Undead", N1="Undead", K1="Undead", W1="Undead", M2="Undead", D2="Undead", C2="Undead", B2="Undead", N2="Undead", K2="Undead", W2="Undead" },
      ["Void Elf"] = { M1="Void Elf", D1="Void Elf", C1="Void Elf", B1="Void Elf", N1="Void Elf", K1="Void Elf", W1="Void Elf", M2="Void Elf", D2="Void Elf", C2="Void Elf", B2="Void Elf", N2="Void Elf", K2="Void Elf", W2="Void Elf" },
      ["Worgen"] = { M1="Worgen", D1="Worgen", C1="Worgen", B1="Worgen", N1="Worgen", K1="Worgen", W1="Worgen", M2="Worgen", D2="Worgen", C2="Worgen", B2="Worgen", N2="Worgen", K2="Worgen", W2="Worgen" },
      ["Zandalari Troll"] = { M1="Zandalari Troll", D1="Zandalari Troll", C1="Zandalari Troll", B1="Zandalari Troll", N1="Zandalari Troll", K1="Zandalari Troll", W1="Zandalari Troll", M2="Zandalari Troll", D2="Zandalari Troll", C2="Zandalari Troll", B2="Zandalari Troll", N2="Zandalari Troll", K2="Zandalari Troll", W2="Zandalari Troll" }, }
local p_class = {
      ["Death Knight "] = { M1="Death Knight",D1="Death Knight", C1="Death Knight", B1="Death Knight", N1="Death Knight", K1="Death Knight", W1="Death Knight", M2="Death Knight", D2="Death Knight", C2="Death Knight", B2="Death Knight", N2="Death Knight", K2="Death Knight", W2="Death Knight" },
      ["Demon Hunter "] = { M1="Demon Hunter",D1="Demon Hunter", C1="Demon Hunter", B1="Demon Hunter", N1="Demon Hunter", K1="Demon Hunter", W1="Demon Hunter", M2="Demon Hunter", D2="Demon Hunter", C2="Demon Hunter", B2="Demon Hunter", N2="Demon Hunter", K2="Demon Hunter", W2="Demon Hunter" },
      ["Druid "] = { M1="Druid",D1="Druid", C1="Druid", B1="Druid", N1="Druid", K1="Druid", W1="Druid", M2="Druid", D2="Druid", C2="Druid", B2="Druid", N2="Druid", K2="Druid", W2="Druid" },
      ["Hunter "] = { M1="Hunter",D1="Hunter", C1="Hunter", B1="Hunter", N1="Hunter", K1="Hunter", W1="Hunter", M2="Hunter", D2="Hunter", C2="Hunter", B2="Hunter", N2="Hunter", K2="Hunter", W2="Hunter" },
      ["Mage "] = { M1="Mage",D1=" Mage ", C1="Mage", B1="Mage", N1="Mage", K1="Mage", W1="Mage", M2="Mage", D2="Mage", C2="Mage", B2="Mage", N2="Mage", K2="Mage", W2="Mage" },
      ["Monk "] = { M1="Monk",D1="Monk", C1="Monk", B1="Monk", N1="Monk", K1="Monk", W1="Monk", M2="Monk", D2="Monk", C2="Monk", B2="Monk", N2="Monk", K2="Monk", W2="Monk" },
      ["Paladin"] = { M1="Paladin",D1="Paladin", C1="Paladin", B1="Paladin", N1="Paladin", K1="Paladin", W1="Paladin", M2="Paladin", D2="Paladin", C2="Paladin", B2="Paladin", N2="Paladin", K2="Paladin", W2="Paladin" },
      ["Priest"] = { M1="Priest",D1="Priest", C1="Priest", B1="Priest", N1="Priest", K1="Priest", W1="Priest", M2="Priest", D2="Priest", C2="Priest", B2="Priest", N2="Priest", K2="Priest", W2="Priest" },
      ["Rogue "] = { M1="Rogue",D1="Rogue", C1="Rogue", B1="Rogue", N1="Rogue", K1="Rogue", W1="Rogue", M2="Rogue", D2="Rogue", C2="Rogue", B2="Rogue", N2="Rogue", K2="Rogue", W2="Rogue" },
      ["Shaman "] = { M1="Shaman",D1="Shaman", C1="Shaman", B1="Shaman", N1="Shaman", K1="Shaman", W1="Shaman", M2="Shaman", D2="Shaman", C2="Shaman", B2="Shaman", N2="Shaman", K2="Shaman", W2="Shaman" },
      ["Warlock"] = { M1="Warlock",D1="Warlock", C1="Warlock", B1="Warlock", N1="Warlock", K1="Warlock", W1="Warlock", M2="Warlock", D2="Warlock", C2="Warlock", B2="Warlock", N2="Warlock", K2="Warlock", W2="Warlock" },
      ["Warrior"] = { M1="Warrior",D1="Warrior", C1="Warrior", B1="Warrior", N1="Warrior", K1="Warrior", W1="Warrior", M2="Warrior", D2="Warrior", C2="Warrior", B2="Warrior", N2="Warrior", K2="Warrior", W2="Warrior" }, }
if (p_race[QTR_race]) then      
   player_race = { M1=p_race[QTR_race].M1, D1=p_race[QTR_race].D1, C1=p_race[QTR_race].C1, B1=p_race[QTR_race].B1, N1=p_race[QTR_race].N1, K1=p_race[QTR_race].K1, W1=p_race[QTR_race].W1, M2=p_race[QTR_race].M2, D2=p_race[QTR_race].D2, C2=p_race[QTR_race].C2, B2=p_race[QTR_race].B2, N2=p_race[QTR_race].N2, K2=p_race[QTR_race].K2, W2=p_race[QTR_race].W2 };
else   
   player_race = { M1=QTR_race, D1=QTR_race, C1=QTR_race, B1=QTR_race, N1=QTR_race, K1=QTR_race, W1=QTR_race, M2=QTR_race, D2=QTR_race, C2=QTR_race, B2=QTR_race, N2=QTR_race, K2=QTR_race, W2=QTR_race };
   print ("|cff55ff00QTR - Nuova Razza: "..QTR_race);
end
if (p_class[QTR_class]) then
   player_class = { M1=p_class[QTR_class].M1, D1=p_class[QTR_class].D1, C1=p_class[QTR_class].C1, B1=p_class[QTR_class].B1, N1=p_class[QTR_class].N1, K1=p_class[QTR_class].K1, W1=p_class[QTR_class].W1, M2=p_class[QTR_class].M2, D2=p_class[QTR_class].D2, C2=p_class[QTR_class].C2, B2=p_class[QTR_class].B2, N2=p_class[QTR_class].N2, K2=p_class[QTR_class].K2, W2=p_class[QTR_class].W2 };
else
   player_class = { M1=QTR_class, D1=QTR_class, C1=QTR_class, B1=QTR_class, N1=QTR_class, K1=QTR_class, W1=QTR_class, M2=QTR_class, D2=QTR_class, C2=QTR_class, B2=QTR_class, N2=QTR_class, K2=QTR_class, W2=QTR_class };
   print ("|cff55ff00QTR - Nuova Classe: "..QTR_class);
end


local function StringHash(text)           -- funzione che crea l'hash (numero a 32 bit) di un determinato testo
  local counter = 1;
  local pomoc = 0;
  local dlug = string.len(text);
  for i = 1, dlug, 3 do 
    counter = math.fmod(counter*8161, 4294967279);  -- 2^32 - 17: Prime!
    pomoc = (string.byte(text,i)*16776193);
    counter = counter + pomoc;
    pomoc = ((string.byte(text,i+1) or (dlug-i+256))*8372226);
    counter = counter + pomoc;
    pomoc = ((string.byte(text,i+2) or (dlug-i+256))*3932164);
    counter = counter + pomoc;
  end
  return math.fmod(counter, 4294967291) -- 2^32 - 5: Prime (and different from the prime in the loop)
end


-- Variabili di programma salvate permanentemente sul computer
function QTR_CheckVars()
  if (not QTR_PS) then
     QTR_PS = {};
  end
  if (not QTR_SAVED) then
     QTR_SAVED = {};
  end
  if (not QTR_MISSING) then
     QTR_MISSING = {};
  end
  if (not QTR_GOSSIP) then
     QTR_GOSSIP = {};
  end
  if (not QTR_CONTROL) then
     QTR_CONTROL = {};
  end
  -- inizializzazione: traduzioni incluse
  if (not QTR_PS["active"]) then
     QTR_PS["active"] = "1";
  end
  -- Inizializzazione: traduzione del titolo della missione inclusa
  if (not QTR_PS["transtitle"] ) then
     QTR_PS["transtitle"] = "0";   
  end
  -- variabile speciale della disponibilità della funzione GetQuestID 
  if ( QTR_PS["isGetQuestID"] ) then
     isGetQuestID=QTR_PS["isGetQuestID"];
  end;
  -- visualizzazione periodica di annunci sul componente aggiuntivo
  if (not QTR_PS["Reklama"] ) then
     QTR_PS["Reklama"] = "0";
     QTR_PS["period"] = 20;
     QTR_PS["text1"] = "0";
     QTR_PS["text2"] = "1";
     QTR_PS["channel"] = "0";
  end;
  if (not QTR_PS["other1"] ) then
     QTR_PS["other1"] = "1";
  end;
  if (not QTR_PS["other2"] ) then
     QTR_PS["other2"] = "1";
  end;
  if (not QTR_PS["other3"] ) then
     QTR_PS["other3"] = "1";
  end;
  if (not QTR_PS["channel"] ) then
     QTR_PS["channel"] = "0";
  end;
   -- record di controllo delle missioni EN originali
  if (not QTR_PS["control"]) then
     QTR_PS["control"] = "1";
  end
   -- salva la versione della patch Wow
  if (not QTR_PS["patch"]) then
     QTR_PS["patch"] = GetBuildInfo();
  end
 -- nome del giocatore per personaggio
  if (not QTR_PC) then
     QTR_PC = {};
  end
  if (not QTR_PC["name1"] ) then
     QTR_PC["name1"] = QTR_name;
  end;
  if (not QTR_PC["name2"] ) then
     QTR_PC["name2"] = QTR_name.."a";
  end;
  if (not QTR_PC["name3"] ) then
     QTR_PC["name3"] = QTR_name.."owi";
  end;
  if (not QTR_PC["name4"] ) then
     QTR_PC["name4"] = QTR_name.."a";
  end;
  if (not QTR_PC["name5"] ) then
     QTR_PC["name5"] = QTR_name.."em";
  end;
  if (not QTR_PC["name6"] ) then
     QTR_PC["name6"] = QTR_name.."ie";
  end;
  if (not QTR_PC["name7"] ) then
     QTR_PC["name7"] = QTR_name;
  end;
  QTR_GS = {};       -- tavola per testi originali
end


-- Verifica la disponibilità della funzione speciale di Wow: GetQuestID ()
function DetectEmuServer()
  QTR_PS["isGetQuestID"]="0";
  isGetQuestID="0";
  -- la funzione GetQuestID () appare solo sui server Blizzard originali
  if ( GetQuestID() ) then
     QTR_PS["isGetQuestID"]="1";
     isGetQuestID="1";
  end
end


-- Supporto comandi barra
function QTR_SlashCommand(msg)
   if (msg=="on" or msg=="ON") then
      if (QTR_PS["active"]=="1") then
         print ("QTR - la traduzione è inclusa.");
      else
         print ("|cffffff00QTR - Attivo la traduzione.");
         QTR_PS["active"] = "1";
         QTR_ToggleButton0:Enable();
         QTR_ToggleButton1:Enable();
         QTR_ToggleButton2:Enable();
         if (isQuestGuru()) then
            QTR_ToggleButton3:Enable();
         end
         if (isImmersion()) then
            QTR_ToggleButton4:Enable();
         end
         QTR_Translate_On(1);
      end
   elseif (msg=="off" or msg=="OFF") then
      if (QTR_PS["active"]=="0") then
         print ("QTR - le traduzioni sono disabilitate.");
      else
         print ("|cffffff00QTR - disattivazione delle traduzioni.");
         QTR_PS["active"] = "0";
         QTR_ToggleButton0:Disable();
         QTR_ToggleButton1:Disable();
         QTR_ToggleButton2:Disable();
         if (isQuestGuru()) then
            QTR_ToggleButton3:Disable();
         end
         if (isImmersion()) then
            QTR_ToggleButton4:Disable();
         end
         QTR_Translate_Off(1);
      end
   elseif (msg=="title on" or msg=="TITLE ON" or msg=="title 1") then
      if (QTR_PS["transtilte"]=="1") then
         print ("QTR - la traduzione del titolo è inclusa.");
      else
         print ("|cffffff00QTR - attivare la traduzione del titolo.");
         QTR_PS["transtitle"] = "1";
         QuestInfoTitleHeader:SetFont(QTR_Font1, 18);
      end
   elseif (msg=="title off" or msg=="TITLE OFF" or msg=="title 0") then
      if (QTR_PS["transtilte"]=="0") then
         print ("QTR - la traduzione del titolo è disabilitata.");
      else
         print ("|cffffff00QTR - disattivazione della traduzione del titolo.");
         QTR_PS["transtitle"] = "0";
         QuestInfoTitleHeader:SetFont(Original_Font1, 18);
      end
   elseif (msg=="title" or msg=="TITLE") then
      if (QTR_PS["transtilte"]=="1") then
         print ("QTR - la traduzione del titolo è abilitata.");
      else
         print ("QTR - la traduzione del titolo è disabilitata.");
      end
   elseif (msg=="") then
      InterfaceOptionsFrame_Show();
      InterfaceOptionsFrame_OpenToCategory("WoWita-Quests");
   else
      print ("QTR - menu dei comandi di aggiunta rapida:");
      print ("      /qtr on  - abilita le traduzioni");
      print ("      /qtr off - disabilita le traduzioni");
      print ("      /qtr title on  - abilita la traduzione del titolo");
      print ("      /qtr title off - disabilita la traduzione del titolo");
   end
   if (QTR_PS["Reklama"]=="1") then
      QTR_SendReklama();
   end
end



function QTR_SetCheckButtonState()
  QTRCheckButton0:SetChecked(QTR_PS["active"]=="1");
  QTRCheckButton3:SetChecked(QTR_PS["transtitle"]=="1");
  QTRCheckButton5:SetChecked(QTR_PS["Reklama"]=="1");
  QTRCheckText1:SetChecked(QTR_PS["text1"]=="1");
  QTRCheckText2:SetChecked(QTR_PS["text2"]=="1");
  QTRCheckOther1:SetChecked(QTR_PS["other1"]=="1");
  QTRCheckOther2:SetChecked(QTR_PS["other2"]=="1");
  QTRCheckOther3:SetChecked(QTR_PS["other3"]=="1");
  QTREditBox:SetText(QTR_PS["channel"]);
  QTREditP1:SetText(QTR_PC["name1"]);
  QTREditP2:SetText(QTR_PC["name2"]);
  QTREditP3:SetText(QTR_PC["name3"]);
  QTREditP4:SetText(QTR_PC["name4"]);
  QTREditP5:SetText(QTR_PC["name5"]);
  QTREditP6:SetText(QTR_PC["name6"]);
  QTREditP7:SetText(QTR_PC["name7"]);
end



function QTR_BlizzardOptions()
  -- Create main frame for information text
  local QTROptions = CreateFrame("FRAME", "WoWIta");
  QTROptions.name = "WoWIta";
  QTROptions.refresh = function (self) QTR_SetCheckButtonState() end;
  InterfaceOptions_AddCategory(QTROptions);

  local QTROptionsHeader = QTROptions:CreateFontString(nil, "ARTWORK");
  QTROptionsHeader:SetFontObject(GameFontNormalLarge);
  QTROptionsHeader:SetJustifyH("LEFT"); 
  QTROptionsHeader:SetJustifyV("TOP");
  QTROptionsHeader:ClearAllPoints();
  QTROptionsHeader:SetPoint("TOPLEFT", 16, -16);
  QTROptionsHeader:SetText("WoWIta, ver. "..QTR_version.." ("..QTR_base..") by Icedany");

  local QTRDateOfBase = QTROptions:CreateFontString(nil, "ARTWORK");
  QTRDateOfBase:SetFontObject(GameFontNormalLarge);
  QTRDateOfBase:SetJustifyH("LEFT"); 
  QTRDateOfBase:SetJustifyV("TOP");
  QTRDateOfBase:ClearAllPoints();
  QTRDateOfBase:SetPoint("TOPRIGHT", QTROptionsHeader, "TOPRIGHT", 0, -22);
  QTRDateOfBase:SetText(""..QTR_date);
  QTRDateOfBase:SetFont(QTR_Font2, 16);

  local QTRCheckButton0 = CreateFrame("CheckButton", "QTRCheckButton0", QTROptions, "OptionsCheckButtonTemplate");
  QTRCheckButton0:SetPoint("TOPLEFT", QTROptionsHeader, "BOTTOMLEFT", 0, -20);
  QTRCheckButton0:SetScript("OnClick", function(self) if (QTR_PS["active"]=="1") then QTR_PS["active"]="0" else QTR_PS["active"]="1" end; end);
  QTRCheckButton0Text:SetFont(QTR_Font2, 13);
  QTRCheckButton0Text:SetText(QTR_Interface.active);

  local QTROptionsMode1 = QTROptions:CreateFontString(nil, "ARTWORK");
  QTROptionsMode1:SetFontObject(GameFontWhite);
  QTROptionsMode1:SetJustifyH("LEFT");
  QTROptionsMode1:SetJustifyV("TOP");
  QTROptionsMode1:ClearAllPoints();
  QTROptionsMode1:SetPoint("TOPLEFT", QTRCheckButton0, "BOTTOMLEFT", 30, -20);
  QTROptionsMode1:SetFont(QTR_Font2, 13);
  QTROptionsMode1:SetText(QTR_Interface.options1);
  
  local QTRCheckButton3 = CreateFrame("CheckButton", "QTRCheckButton3", QTROptions, "OptionsCheckButtonTemplate");
  QTRCheckButton3:SetPoint("TOPLEFT", QTROptionsMode1, "BOTTOMLEFT", 0, -5);
  QTRCheckButton3:SetScript("OnClick", function(self) if (QTR_PS["transtitle"]=="0") then QTR_PS["transtitle"]="1" else QTR_PS["transtitle"]="0" end; end);
  QTRCheckButton3Text:SetFont(QTR_Font2, 13);
  QTRCheckButton3Text:SetText(QTR_Interface.transtitle);


  
  local QTREditP1 = CreateFrame("EditBox", "QTREditP1", QTROptions, "InputBoxTemplate");
  QTREditP1:SetPoint("TOPRIGHT", QTROptionsMode2, "BOTTOMRIGHT", 0, -10);
  QTREditP1:SetHeight(20);
  QTREditP1:SetWidth(100);
  QTREditP1:SetAutoFocus(false);
  QTREditP1:SetText(QTR_PC["name1"]);
  QTREditP1:SetCursorPosition(0);
  QTREditP1:SetScript("OnTextChanged", function(self) if (strlen(QTREditP1:GetText())>0) then QTR_PC["name1"]=QTREditP1:GetText() end; end);

  local QTRName1 = QTROptions:CreateFontString(nil, "ARTWORK");
  QTRName1:SetFontObject(GameFontNormalLarge);
  QTRName1:SetJustifyH("LEFT"); 
  QTRName1:SetJustifyV("TOP");
  QTRName1:ClearAllPoints();
  QTRName1:SetPoint("TOPRIGHT", QTREditP1, "TOPLEFT", -8, -4);
  QTRName1:SetText("denominatore");
  QTRName1:SetFont(QTR_Font2, 13);

  local QTREditP2 = CreateFrame("EditBox", "QTREditP2", QTROptions, "InputBoxTemplate");
  QTREditP2:SetPoint("TOPRIGHT", QTREditP1, "BOTTOMRIGHT", 0, 0);
  QTREditP2:SetHeight(20);
  QTREditP2:SetWidth(100);
  QTREditP2:SetAutoFocus(false);
  QTREditP2:SetText(QTR_PC["name2"]);
  QTREditP2:SetCursorPosition(0);
  QTREditP2:SetScript("OnTextChanged", function(self) if (strlen(QTREditP2:GetText())>0) then QTR_PC["name2"]=QTREditP2:GetText() end; end);

  local QTRName2 = QTROptions:CreateFontString(nil, "ARTWORK");
  QTRName2:SetFontObject(GameFontNormalLarge);
  QTRName2:SetJustifyH("LEFT"); 
  QTRName2:SetJustifyV("TOP");
  QTRName2:ClearAllPoints();
  QTRName2:SetPoint("TOPRIGHT", QTREditP2, "TOPLEFT", -8, -4);
  QTRName2:SetText("genitivo");
  QTRName2:SetFont(QTR_Font2, 13);

  local QTREditP3 = CreateFrame("EditBox", "QTREditP3", QTROptions, "InputBoxTemplate");
  QTREditP3:SetPoint("TOPRIGHT", QTREditP2, "BOTTOMRIGHT", 0, 0);
  QTREditP3:SetHeight(20);
  QTREditP3:SetWidth(100);
  QTREditP3:SetAutoFocus(false);
  QTREditP3:SetText(QTR_PC["name3"]);
  QTREditP3:SetCursorPosition(0);
  QTREditP3:SetScript("OnTextChanged", function(self) if (strlen(QTREditP3:GetText())>0) then QTR_PC["name3"]=QTREditP3:GetText() end; end);

  local QTRName3 = QTROptions:CreateFontString(nil, "ARTWORK");
  QTRName3:SetFontObject(GameFontNormalLarge);
  QTRName3:SetJustifyH("LEFT"); 
  QTRName3:SetJustifyV("TOP");
  QTRName3:ClearAllPoints();
  QTRName3:SetPoint("TOPRIGHT", QTREditP3, "TOPLEFT", -8, -4);
  QTRName3:SetText("mirino");
  QTRName3:SetFont(QTR_Font2, 13);

  local QTREditP4 = CreateFrame("EditBox", "QTREditP4", QTROptions, "InputBoxTemplate");
  QTREditP4:SetPoint("TOPRIGHT", QTREditP3, "BOTTOMRIGHT", 0, 0);
  QTREditP4:SetHeight(20);
  QTREditP4:SetWidth(100);
  QTREditP4:SetAutoFocus(false);
  QTREditP4:SetText(QTR_PC["name4"]);
  QTREditP4:SetCursorPosition(0);
  QTREditP4:SetScript("OnTextChanged", function(self) if (strlen(QTREditP4:GetText())>0) then QTR_PC["name4"]=QTREditP4:GetText() end; end);

  local QTRName4 = QTROptions:CreateFontString(nil, "ARTWORK");
  QTRName4:SetFontObject(GameFontNormalLarge);
  QTRName4:SetJustifyH("LEFT"); 
  QTRName4:SetJustifyV("TOP");
  QTRName4:ClearAllPoints();
  QTRName4:SetPoint("TOPRIGHT", QTREditP4, "TOPLEFT", -8, -4);
  QTRName4:SetText("accusativo");
  QTRName4:SetFont(QTR_Font2, 13);

  local QTREditP5 = CreateFrame("EditBox", "QTREditP5", QTROptions, "InputBoxTemplate");
  QTREditP5:SetPoint("TOPRIGHT", QTREditP4, "BOTTOMRIGHT", 0, 0);
  QTREditP5:SetHeight(20);
  QTREditP5:SetWidth(100);
  QTREditP5:SetAutoFocus(false);
  QTREditP5:SetText(QTR_PC["name5"]);
  QTREditP5:SetCursorPosition(0);
  QTREditP5:SetScript("OnTextChanged", function(self) if (strlen(QTREditP5:GetText())>0) then QTR_PC["name5"]=QTREditP5:GetText() end; end);

  local QTRName5 = QTROptions:CreateFontString(nil, "ARTWORK");
  QTRName5:SetFontObject(GameFontNormalLarge);
  QTRName5:SetJustifyH("LEFT"); 
  QTRName5:SetJustifyV("TOP");
  QTRName5:ClearAllPoints();
  QTRName5:SetPoint("TOPRIGHT", QTREditP5, "TOPLEFT", -8, -4);
  QTRName5:SetText("strumentale");
  QTRName5:SetFont(QTR_Font2, 13);

  local QTREditP6 = CreateFrame("EditBox", "QTREditP6", QTROptions, "InputBoxTemplate");
  QTREditP6:SetPoint("TOPRIGHT", QTREditP5, "BOTTOMRIGHT", 0, 0);
  QTREditP6:SetHeight(20);
  QTREditP6:SetWidth(100);
  QTREditP6:SetAutoFocus(false);
  QTREditP6:SetText(QTR_PC["name6"]);
  QTREditP6:SetCursorPosition(0);
  QTREditP6:SetScript("OnTextChanged", function(self) if (strlen(QTREditP6:GetText())>0) then QTR_PC["name6"]=QTREditP6:GetText() end; end);

  local QTRName6 = QTROptions:CreateFontString(nil, "ARTWORK");
  QTRName6:SetFontObject(GameFontNormalLarge);
  QTRName6:SetJustifyH("LEFT"); 
  QTRName6:SetJustifyV("TOP");
  QTRName6:ClearAllPoints();
  QTRName6:SetPoint("TOPRIGHT", QTREditP6, "TOPLEFT", -8, -4);
  QTRName6:SetText("locativo");
  QTRName6:SetFont(QTR_Font2, 13);

  local QTREditP7 = CreateFrame("EditBox", "QTREditP7", QTROptions, "InputBoxTemplate");
  QTREditP7:SetPoint("TOPRIGHT", QTREditP6, "BOTTOMRIGHT", 0, 0);
  QTREditP7:SetHeight(20);
  QTREditP7:SetWidth(100);
  QTREditP7:SetAutoFocus(false);
  QTREditP7:SetText(QTR_PC["name7"]);
  QTREditP7:SetCursorPosition(0);
  QTREditP7:SetScript("OnTextChanged", function(self) if (strlen(QTREditP7:GetText())>0) then QTR_PC["name7"]=QTREditP7:GetText() end; end);

  local QTRName7 = QTROptions:CreateFontString(nil, "ARTWORK");
  QTRName7:SetFontObject(GameFontNormalLarge);
  QTRName7:SetJustifyH("LEFT"); 
  QTRName7:SetJustifyV("TOP");
  QTRName7:ClearAllPoints();
  QTRName7:SetPoint("TOPRIGHT", QTREditP7, "TOPLEFT", -8, -4);
  QTRName7:SetText("vocativo");
  QTRName7:SetFont(QTR_Font2, 13);

  local QTRCheckButton5 = CreateFrame("CheckButton", "QTRCheckButton5", QTROptions, "OptionsCheckButtonTemplate");
  QTRCheckButton5:SetPoint("TOPLEFT", QTRCheckButton3, "BOTTOMLEFT", 0, -20);
  QTRCheckButton5:SetScript("OnClick", function(self) if (QTR_PS["Reklama"]=="0") then QTR_PS["Reklama"]="1" else QTR_PS["Reklama"]="0" end; end);
  QTRCheckButton5Text:SetFont(QTR_Font2, 13);
  QTRCheckButton5Text:SetText(QTR_Reklama.ON);

  
 local QTREditBox = CreateFrame("EditBox", "QTREditBox", QTROptions, "InputBoxTemplate");
  QTREditBox:SetPoint("TOPLEFT", QTRCheckButton5Text, "TOPRIGHT", 10, 3);
  QTREditBox:SetHeight(20);
  QTREditBox:SetWidth(20);
  QTREditBox:SetAutoFocus(false);
  QTREditBox:SetText(QTR_PS["channel"]);
  QTREditBox:SetCursorPosition(0);
  QTREditBox:SetScript("OnTextChanged", function(self) if (strlen(QTREditBox:GetText())>0) then QTR_PS["channel"]=QTREditBox:GetText() end; end);

--  local QTRChannelsFrame = CreateFrame("frame", "QTRChannelsFrame", QTROptions, "UIDropDownMenuTemplate")
--  QTRChannelsFrame:SetPoint("TOPLEFT", QTREditBox, "BOTTOMRIGHT", -150, 0);
--  UIDropDownMenu_SetText(QTRChannelsFrame, "Dostepne kanały:");
--  QTRChannelsFrame.onClick = function(self, arg1, arg2, checked) QTREditBox:SetText(arg1); end
--  QTRChannelsFrame.initialize = function(self, level)
--	  local info = UIDropDownMenu_CreateInfo();
--     info.text = "0: LocalArea SAY";
--     info.value= "0";
--     info.func = self.onClick;
--     info.arg1 = "0";
--     info.arg2 = "LocalArea SAY";
--     UIDropDownMenu_AddButton(info, level);
--     local ind1 = "0";
--     for ind,nam in ipairs({GetChannelList()}) do
--        if nam and (strlen(nam)==1) then
--           ind1 = nam;      -- channel number     
--        else
--           info.text = ind1 .. ": " .. nam;        -- nam wychodzi jako BOOLEAN
--           info.value= ind1;
--           info.func = self.onClick;
--           info.arg1 = ind1;
--           info.arg2 = nam;
--           UIDropDownMenu_AddButton(info, level);
--	     end
--     end
--  end   
  
  local QTRPeriodText = QTROptions:CreateFontString(nil, "ARTWORK");
  QTRPeriodText:SetFontObject(GameFontWhite);
  QTRPeriodText:SetJustifyH("LEFT");
  QTRPeriodText:SetJustifyV("TOP");
  QTRPeriodText:ClearAllPoints();
  QTRPeriodText:SetPoint("TOPLEFT", QTRCheckButton5, "BOTTOMLEFT", 30, -20);
  QTRPeriodText:SetFont(QTR_Font2, 13);
  QTRPeriodText:SetText(QTR_Reklama.PERIOD);
  
  local QTR_slider = CreateFrame("Slider","MyAddonSlider",QTROptions,'OptionsSliderTemplate');
  QTR_slider:ClearAllPoints();
  QTR_slider:SetPoint("TOPLEFT",QTRPeriodText, "BOTTOMLEFT", 80, -30);
  getglobal(QTR_slider:GetName() .. 'Low'):SetText('15 min.');
  getglobal(QTR_slider:GetName() .. 'High'):SetText('90 min.');
  getglobal(QTR_slider:GetName() .. 'Text'):SetText('20 min.');
  QTR_slider:SetMinMaxValues(15, 90);
  QTR_slider:SetValue(QTR_PS["period"]);
  getglobal(QTR_slider:GetName() .. 'Text'):SetText(QTR_PS["period"] .. " min.");
  QTR_slider:SetValueStep(5);
  QTR_slider:SetScript("OnValueChanged", function(self)
      QTR_PS["period"] = math.floor(QTR_slider:GetValue()+0.5);
      getglobal(QTR_slider:GetName() .. 'Text'):SetText(QTR_PS["period"] .. " min.");
      end);

  local QTRChoiceText = QTROptions:CreateFontString(nil, "ARTWORK");
  QTRChoiceText:SetFontObject(GameFontWhite);
  QTRChoiceText:SetJustifyH("LEFT");
  QTRChoiceText:SetJustifyV("TOP");
  QTRChoiceText:ClearAllPoints();
  QTRChoiceText:SetPoint("TOPLEFT", QTRPeriodText, "BOTTOMLEFT", -50, -80);
  QTRChoiceText:SetFont(QTR_Font2, 13);
  QTRChoiceText:SetText(QTR_Reklama.CHOICE);
  
  local QTRCheckText1 = CreateFrame("CheckButton", "QTRCheckText1", QTROptions, "OptionsCheckButtonTemplate");
  QTRCheckText1:SetPoint("TOPLEFT", QTRChoiceText, "BOTTOMLEFT", -10, -10);
  QTRCheckText1:SetScript("OnClick", function(self) if (QTR_PS["text1"]=="0") then QTR_PS["text1"]="1" else QTR_PS["text1"]="0" end; end);
  QTRCheckText1Text:SetFont(QTR_Font2, 13);
  QTRCheckText1Text:SetText(QTR_Reklama.TEXT1);

  local QTRCheckText2 = CreateFrame("CheckButton", "QTRCheckText2", QTROptions, "OptionsCheckButtonTemplate");
  QTRCheckText2:SetPoint("TOPLEFT", QTRCheckText1, "BOTTOMLEFT", 0, 0);
  QTRCheckText2:SetScript("OnClick", function(self) if (QTR_PS["text2"]=="0") then QTR_PS["text2"]="1" else QTR_PS["text2"]="0" end; end);
  QTRCheckText2Text:SetFont(QTR_Font2, 13);
  QTRCheckText2Text:SetText(QTR_Reklama.TEXT2);
  
  local QTRIntegration0 = QTROptions:CreateFontString(nil, "ARTWORK");
  QTRIntegration0:SetFontObject(GameFontWhite);
  QTRIntegration0:SetJustifyH("LEFT");
  QTRIntegration0:SetJustifyV("TOP");
  QTRIntegration0:ClearAllPoints();
  QTRIntegration0:SetPoint("TOPLEFT", QTRCheckText2, "BOTTOMLEFT", 0, -20);
  QTRIntegration0:SetFont(QTR_Font2, 13);
  QTRIntegration0:SetText("Integrazione con altri componenti aggiuntivi:");
  
  local QTRIntegration1 = QTROptions:CreateFontString(nil, "ARTWORK");
  QTRIntegration1:SetFontObject(GameFontNormal);
  QTRIntegration1:SetJustifyH("LEFT");
  QTRIntegration1:SetJustifyV("TOP");
  QTRIntegration1:ClearAllPoints();
  QTRIntegration1:SetPoint("TOPLEFT", QTRIntegration0, "TOPRIGHT", 15, 0);
  QTRIntegration1:SetFont(QTR_Font2, 13);
  QTRIntegration1:SetText("QuestGuru,  Immersion,  Storyline");

  local QTRCheckOther1 = CreateFrame("CheckButton", "QTRCheckOther1", QTROptions, "OptionsCheckButtonTemplate");
  QTRCheckOther1:SetPoint("TOPLEFT", QTRIntegration1, "BOTTOMLEFT", -10, -10);
  QTRCheckOther1:SetScript("OnClick", function(self) if (QTR_PS["other1"]=="0") then QTR_PS["other1"]="1" else QTR_PS["other1"]="0" end; end);
  QTRCheckOther1Text:SetFont(QTR_Font2, 13);
  if (QuestGuru ~= nil ) then
     QTRCheckOther1Text:SetText(QTR_Reklama.OTHER1..QTR_Reklama.ACTIV1);
  else
     QTRCheckOther1Text:SetText(QTR_Reklama.OTHER1..QTR_Reklama.ACTIV2);
  end

  local QTRCheckOther2 = CreateFrame("CheckButton", "QTRCheckOther2", QTROptions, "OptionsCheckButtonTemplate");
  QTRCheckOther2:SetPoint("TOPLEFT", QTRCheckOther1, "BOTTOMLEFT", 0, 0);
  QTRCheckOther2:SetScript("OnClick", function(self) if (QTR_PS["other2"]=="0") then QTR_PS["other2"]="1" else QTR_PS["other2"]="0" end; end);
  QTRCheckOther2Text:SetFont(QTR_Font2, 13);
  if (ImmersionFrame ~= nil ) then
     QTRCheckOther2Text:SetText(QTR_Reklama.OTHER2..QTR_Reklama.ACTIV1);
  else
     QTRCheckOther2Text:SetText(QTR_Reklama.OTHER2..QTR_Reklama.ACTIV2);
  end
  
  local QTRCheckOther3 = CreateFrame("CheckButton", "QTRCheckOther3", QTROptions, "OptionsCheckButtonTemplate");
  QTRCheckOther3:SetPoint("TOPLEFT", QTRCheckOther2, "BOTTOMLEFT", 0, 0);
  QTRCheckOther3:SetScript("OnClick", function(self) if (QTR_PS["other3"]=="0") then QTR_PS["other3"]="1" else QTR_PS["other3"]="0" end; end);
  QTRCheckOther3Text:SetFont(QTR_Font2, 13);
  QTRCheckOther3Text:SetText(QTR_Reklama.OTHER3);
  

  
  local QTRWWW2 = CreateFrame("EditBox", "QTRWWW2", QTROptions, "InputBoxTemplate");
  QTRWWW2:ClearAllPoints();
  QTRWWW2:SetPoint("TOPLEFT", QTRWWW1, "TOPRIGHT", 10, 4);
  QTRWWW2:SetHeight(20);
  QTRWWW2:SetWidth(155);
  QTRWWW2:SetAutoFocus(false);
  QTRWWW2:SetFontObject(GameFontGreen);
  QTRWWW2:SetText(QTR_Reklama.WWW2);
  QTRWWW2:SetCursorPosition(0);
  QTRWWW2:SetScript("OnEnter", function(self)
	  GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT")
      getglobal("GameTooltipTextLeft1"):SetFont(QTR_Font2, 13);
  	  GameTooltip:SetText(QTR_Reklama.WWW3, nil, nil, nil, nil, true)
	  GameTooltip:Show() --Show the tooltip
     end);
  QTRWWW2:SetScript("OnLeave", function(self)
      getglobal("GameTooltipTextLeft1"):SetFont(Original_Font2, 13);
	  GameTooltip:Hide() --Hide the tooltip
     end);
  QTRWWW2:SetScript("OnTextChanged", function(self) QTRWWW2:SetText(QTR_Reklama.WWW2); end);

--  if (ImmersionFrame ~= nil ) then
--     local QTRslider = CreateFrame("Slider", "QTRslider", QTROptions, "OptionsSliderTemplate");
--     QTRslider:SetPoint("TOPLEFT", QTRIntegration0, "BOTTOMLEFT", 0, -40);
--     QTRslider:SetMinMaxValues(0.5, 3.0);
--     QTRslider.minValue, QTRslider.maxValue = QTRslider:GetMinMaxValues();
--     QTRslider.Low:SetText(QTRslider.minValue.." sek");
--     QTRslider.High:SetText(QTRslider.maxValue.." sek");
--     getglobal(QTRslider:GetName() .. 'Text'):SetText('Opóźnienie Immersion');
--     getglobal(QTRslider:GetName() .. 'Text'):SetFont(QTR_Font2, 13);
--     QTRslider:SetValue(QTR_PS["delayImmersion"]);
--     QTRslider:SetValueStep(0.1);
--     QTRslider:SetScript("OnValueChanged", function(self,event,arg1) 
--                                           QTR_PS["delayImmersion"]=string.format("%.1f",event); 
--                                           QTRsliderVal:SetText(QTR_PS["delayImmersion"]);
--                                           end);
--     QTRsliderVal = QTROptions:CreateFontString(nil, "ARTWORK");
--     QTRsliderVal:SetFontObject(GameFontNormal);
--     QTRsliderVal:SetJustifyH("CENTER");
--     QTRsliderVal:SetJustifyV("TOP");
--     QTRsliderVal:ClearAllPoints();
--     QTRsliderVal:SetPoint("CENTER", QTRslider, "CENTER", 0, -12);
--     QTRsliderVal:SetFont(QTR_Font2, 13);
--     QTRsliderVal:SetText(QTR_PS["delayImmersion"]);   
--     end
  
end


function QTR_SaveQuest(event)
   if (event=="QUEST_DETAIL") then
      QTR_SAVED[QTR_quest_EN.id.." TITLE"]=GetTitleText();            -- save original title to future translation
      QTR_SAVED[QTR_quest_EN.id.." DESCRIPTION"]=GetQuestText();      -- save original text to future translation
      QTR_SAVED[QTR_quest_EN.id.." OBJECTIVE"]=GetObjectiveText();    -- save original text to future translation
   end
   if (event=="QUEST_PROGRESS") then
      QTR_SAVED[QTR_quest_EN.id.." PROGRESS"]=GetProgressText();      -- save original text to future translation
   end
   if (event=="QUEST_COMPLETE") then
      QTR_SAVED[QTR_quest_EN.id.." COMPLETE"]=GetRewardText();        -- save original text to future translation
   end
   if (QTR_SAVED[QTR_quest_EN.id.." TITLE"]==nil) then
      QTR_SAVED[QTR_quest_EN.id.." TITLE"]=GetTitleText();            -- zapisz tytył w przypadku tylko Zakończenia
   end
   QTR_SAVED[QTR_quest_EN.id.." PLAYER"]=QTR_name..'@'..QTR_race..'@'..QTR_class;  -- zapisz dane gracza
end


function QTR_wait(delay, func, ...)
  if(type(delay)~="number" or type(func)~="function") then
    return false;
  end
  if (QTR_waitFrame == nil) then
    QTR_waitFrame = CreateFrame("Frame","QTR_WaitFrame", UIParent);
    QTR_waitFrame:SetScript("onUpdate",function (self,elapse)
      local count = #QTR_waitTable;
      local i = 1;
      while(i<=count) do
        local waitRecord = tremove(QTR_waitTable,i);
        local d = tremove(waitRecord,1);
        local f = tremove(waitRecord,1);
        local p = tremove(waitRecord,1);
        if(d>elapse) then
          tinsert(QTR_waitTable,i,{d-elapse,f,p});
          i = i + 1;
        else
          count = count - 1;
          f(unpack(p));
        end
      end
    end);
  end
  tinsert(QTR_waitTable,{delay,func,{...}});
  return true;
end


function QTR_SendReklama()
  local now = GetTime();
  if (last_time + QTR_PS["period"]*60 < now) then                  -- OK, czas wypisać reklamę
     if ((QTR_PS["text1"]=="1") and (QTR_PS["text2"]=="1")) then   -- oba teksty naprzemiennie
        if (last_text==2) then
           if (tonumber(QTR_PS["channel"])>0) then
              SendChatMessage(QTR_Reklama.TEXT1,"CHANNEL",nil,tonumber(QTR_PS["channel"]));
           else
              SendChatMessage(QTR_Reklama.TEXT1,"SAY");
           end
           last_text = 1;
        else
           if (tonumber(QTR_PS["channel"])>0) then
              SendChatMessage(QTR_Reklama.TEXT2,"CHANNEL",nil,tonumber(QTR_PS["channel"]));
           else
              SendChatMessage(QTR_Reklama.TEXT2,"SAY");
           end
           last_text = 2;
        end
     elseif (QTR_PS["text1"]=="1") then
        if (tonumber(QTR_PS["channel"])>0) then
           SendChatMessage(QTR_Reklama.TEXT1,"CHANNEL",nil,tonumber(QTR_PS["channel"]));
        else
           SendChatMessage(QTR_Reklama.TEXT1,"SAY");
        end        
        last_text = 1;
     elseif (QTR_PS["text2"]=="1") then
        if (tonumber(QTR_PS["channel"])>0) then
           SendChatMessage(QTR_Reklama.TEXT2,"CHANNEL",nil,tonumber(QTR_PS["channel"]));
        else
           SendChatMessage(QTR_Reklama.TEXT2,"SAY");
        end
        last_text = 2;
     end
     last_time = now;
  end   
end

function QTR_ON_OFF()
   if (curr_trans=="1") then
      curr_trans="0";
      QTR_Translate_Off(1);
   else   
      curr_trans="1";
      QTR_Translate_On(1);
   end
end


function GS_ON_OFF()
   if (curr_goss=="1") then         -- disattiva traduzione - mostra il testo originale
      curr_goss="0";
      GossipGreetingText:SetText(QTR_GS[curr_hash]);
      GossipGreetingText:SetFont(Original_Font2, 13);      
      QTR_ToggleButtonGS:SetText("Gossip-Hash=["..tostring(curr_hash).."] EN");
   else                             -- Mostra la traduzione IT
      curr_goss="1";
      local Greeting_PL = GS_Gossip[curr_hash];
      GossipGreetingText:SetText(QTR_ExpandUnitInfo(Greeting_PL));
      GossipGreetingText:SetFont(QTR_Font2, 13);      
      QTR_ToggleButtonGS:SetText("Gossip-Hash=["..tostring(curr_hash).."] IT");
   end
end


-- Prima funzione richiamata dopo il caricamento del componente aggiuntivo
function QTR_OnLoad()
   QTR = CreateFrame("Frame");
   QTR:SetScript("OnEvent", QTR_OnEvent);
   QTR:RegisterEvent("ADDON_LOADED");
   QTR:RegisterEvent("QUEST_ACCEPTED");
   QTR:RegisterEvent("QUEST_DETAIL");
   QTR:RegisterEvent("QUEST_PROGRESS");
   QTR:RegisterEvent("QUEST_COMPLETE");
--   QTR:RegisterEvent("QUEST_FINISHED");
--   QTR:RegisterEvent("QUEST_GREETING");
   QTR:RegisterEvent("GOSSIP_SHOW");

   -- Pulsante ID missione in QuestFrame (NPC)
   QTR_ToggleButton0 = CreateFrame("Button",nil, QuestFrame, "UIPanelButtonTemplate");
   QTR_ToggleButton0:SetWidth(150);
   QTR_ToggleButton0:SetHeight(20);
   QTR_ToggleButton0:SetText("Quest ID=?");
   QTR_ToggleButton0:Show();
   QTR_ToggleButton0:ClearAllPoints();
   QTR_ToggleButton0:SetPoint("TOPLEFT", QuestFrame, "TOPLEFT", 120, -50);
   QTR_ToggleButton0:SetScript("OnClick", QTR_ON_OFF);
   
   -- Lunghezza Bottone Quest ID
   QTR_ToggleButton1 = CreateFrame("Button",nil, QuestLogFrame, "UIPanelButtonTemplate");
   QTR_ToggleButton1:SetWidth(120);
   QTR_ToggleButton1:SetHeight(20);
   QTR_ToggleButton1:SetText("Quest ID=?");
   QTR_ToggleButton1:Show();
   QTR_ToggleButton1:ClearAllPoints();
   QTR_ToggleButton1:SetPoint("TOPLEFT", QuestLogFrame, "TOPLEFT", 120, -14);
   QTR_ToggleButton1:SetScript("OnClick", QTR_ON_OFF);

   -- pulsante ID missione in QuestMapDetailsScrollFrame
   QTR_ToggleButton2 = CreateFrame("Button",nil, QuestMapDetailsScrollFrame, "UIPanelButtonTemplate");
   QTR_ToggleButton2:SetWidth(150);
   QTR_ToggleButton2:SetHeight(20);
   QTR_ToggleButton2:SetText("Quest ID=?");
   QTR_ToggleButton2:Show();
   QTR_ToggleButton2:ClearAllPoints();
   QTR_ToggleButton2:SetPoint("TOPLEFT", QuestMapDetailsScrollFrame, "TOPLEFT", 116, 29);
   QTR_ToggleButton2:SetScript("OnClick", QTR_ON_OFF);



   -- funzione chiamata dopo aver fatto clic sul nome della missione in QuestTracker
-- hooksecurefunc (QUEST_TRACKER_MODULE, "OnBlockHeaderClick", QTR_PrepareReload);
   
   -- funzione chiamata dopo aver fatto clic sul nome della missione in QuestLog
  QuestLogDetailScrollFrame:HookScript("OnShow", QTR_Prepare1sek);
  EmptyQuestLogFrame:HookScript("OnShow", QTR_EmptyQuestLog);
  hooksecurefunc("SelectQuestLogEntry", QTR_Prepare1sek);

-- QuestLogTitleButton: HookScript ("OnClick", QTR_PrepareReload);
-- se hooksecurefunc allora
-- hooksecurefunc ("QuestLogTitleButton_OnClick", function () QTR_PrepareReload () end);
-- fine

-- hooksecurefunc ("QuestMapFrame_ShowQuestDetails", QTR_PrepareReload);
   
   isQuestGuru();
   isImmersion();
   isStoryline();
end


function isQuestGuru()
   if (QuestGuru ~= nil ) then
      if (QTR_ToggleButton3==nil) then
         -- przycisk z nr ID questu w QuestGuru
         QTR_ToggleButton3 = CreateFrame("Button",nil, QuestGuru, "UIPanelButtonTemplate");
         QTR_ToggleButton3:SetWidth(150);
         QTR_ToggleButton3:SetHeight(20);
         QTR_ToggleButton3:SetText("Quest ID=?");
         QTR_ToggleButton3:Show();
         QTR_ToggleButton3:ClearAllPoints();
         QTR_ToggleButton3:SetPoint("TOPLEFT", QuestGuru, "TOPLEFT", 330, -33);
         QTR_ToggleButton3:SetScript("OnClick", QTR_ON_OFF);
         -- uaktualniono dane w QuestLogu
         QuestGuru:HookScript("OnUpdate", function() QTR_PrepareReload() end);
      end
      return true;
   else
      return false;   
   end
end


function isImmersion()
   if (ImmersionFrame ~= nil ) then
      if (QTR_ToggleButton4==nil) then
         -- pulsante ID missione
         QTR_ToggleButton4 = CreateFrame("Button",nil, ImmersionFrame.TalkBox, "UIPanelButtonTemplate");
         QTR_ToggleButton4:SetWidth(150);
         QTR_ToggleButton4:SetHeight(20);
         QTR_ToggleButton4:SetText("Quest ID=?");
         QTR_ToggleButton4:Show();
         QTR_ToggleButton4:ClearAllPoints();
         QTR_ToggleButton4:SetPoint("TOPLEFT", ImmersionFrame.TalkBox, "TOPRIGHT", -200, -116);
         QTR_ToggleButton4:SetScript("OnClick", QTR_ON_OFF);
         --aprì la finestra del plugin Immersion: chiamando da OnEvent
         ImmersionFrame.TalkBox:HookScript("OnHide",function() QTR_ToggleButton4:Hide(); end);
         QTR_ToggleButton4:Disable();     -- non può essere ancora premuto
         QTR_ToggleButton4:Hide();        -- pulsante inizialmente invisibile (perché forse c'è una selezione di missioni)
      end
      return true;
   else   
      return false;
   end
end
   

function isStoryline()
   if (Storyline_NPCFrame ~= nil ) then
      if (QTR_ToggleButton5==nil) then
         -- pulsante ID missione
         QTR_ToggleButton5 = CreateFrame("Button",nil, Storyline_NPCFrameChat, "UIPanelButtonTemplate");
         QTR_ToggleButton5:SetWidth(150);
         QTR_ToggleButton5:SetHeight(20);
         QTR_ToggleButton5:SetText("Quest ID=?");
         QTR_ToggleButton5:Hide();
         QTR_ToggleButton5:ClearAllPoints();
         QTR_ToggleButton5:SetPoint("BOTTOMLEFT", Storyline_NPCFrameChat, "BOTTOMLEFT", 244, -16);
         QTR_ToggleButton5:SetScript("OnClick", QTR_ON_OFF);
         Storyline_NPCFrameObjectivesContent:HookScript("OnShow", function() QTR_Storyline_Objectives() end);
         Storyline_NPCFrameRewards:HookScript("OnShow", function() QTR_Storyline_Rewards() end);
         Storyline_NPCFrameChat:HookScript("OnHide", function() QTR_Storyline_Hide() end);
--         QTR_ToggleButton5: Disabilita (); - non può essere premuto
      end
      return true;
   else
      return false;
   end
end


function QTR_GetQuestID(event)
   local quest_ID = nil;
   local selectQuestIndex, questId, questData;

   -- Metodo per il Quest Log (per missioni accettate)
   if QuestLogFrame and QuestLogFrame:IsVisible() then
      quest_ID  = select(8, GetQuestLogTitle(GetQuestLogSelection()));
       if QTR_onDebug then
           print("QuestLogFrame: Recuperato Quest ID: ", quest_ID or "nil");
       end
   end

   -- Quest frame
   if QuestFrame:IsShown() and QuestFrame:IsVisible() then
      quest_ID = GetQuestID();
      if QTR_onDebug then
          print("QuestFrame: Recuperato Quest ID: ", quest_ID or "nil");
      end
   end

   -- Metodo specifico per QUEST_DETAIL
   if (quest_ID == nil or quest_ID == 0) and event == "QUEST_DETAIL" then
       local questTitle = GetTitleText();
       local questText = GetQuestText();
       local questObjectives = GetObjectiveText();

       -- Debug per verificare i dati della missione
       if QTR_onDebug then
           print("QUEST_DETAIL: Titolo della missione: ", questTitle or "Nessun titolo");
           print("QUEST_DETAIL: Testo della missione: ", questText or "Nessun testo");
           print("QUEST_DETAIL: Obiettivi della missione: ", questObjectives or "Nessun obiettivo");
       end

       -- Se il titolo è disponibile, cerchiamo nel quest log
       if questTitle and questTitle ~= "" then
           local i = 1;
           while GetQuestLogTitle(i) do
               local title, _, _, _, _, _, _, questID = GetQuestLogTitle(i);
               if title == questTitle then
                   quest_ID = questID;
                   break;
               end
               i = i + 1;
           end
           if QTR_onDebug then
               print("Titolo trovato durante QUEST_DETAIL: ", questTitle, " -> Quest ID: ", quest_ID or "nil");
           end
       end
   end

   -- Fallback per missioni non accettate
   if (quest_ID == nil or quest_ID == 0) then
       if QTR_onDebug then
           print("ID non trovato in nessun metodo. Potrebbe essere una missione non ancora accettata.");
       end
       quest_ID = 0; -- Default per ID non trovato
   else
       if QTR_onDebug then
           print("Quest ID trovato: ", quest_ID);
       end
   end

   return quest_ID;
end

-- Inviato su eventi acquisiti
function QTR_OnEvent(self, event, name, ...)
   isStoryline();       -- crea un pulsante quando la trama è attiva
   if (QTR_onDebug) then
      print('OnEvent-event: '..event);   
   end   
   if (event=="ADDON_LOADED" and name=="WoWita_Quests") then
      SlashCmdList["WOWita_QUESTS"] = function(msg) QTR_SlashCommand(msg); end
      SLASH_WOWita_QUESTS1 = "/wowita-quests";
      SLASH_WOWita_QUESTS2 = "/qtr";
      QTR_CheckVars();
      -- twórz interface Options w Blizzard-Interface-Addons
      QTR_BlizzardOptions();
      print ("|cffffff00WoWita-Quests ver. "..QTR_version.." - "..QTR_Messages.loaded);
      QTR:UnregisterEvent("ADDON_LOADED");
      QTR.ADDON_LOADED = nil;
      if (not isGetQuestID) then
         DetectEmuServer();
      end
   elseif (event=="QUEST_DETAIL" or event=="QUEST_PROGRESS" or event=="QUEST_COMPLETE") then
      if ( QuestFrame:IsVisible() or isImmersion()) then
         QTR_QuestPrepare(event);
      elseif (isStoryline()) then
         if (not QTR_wait(1,QTR_Storyline_Quest)) then
         -- 1 secondo di ritardo
         end
      end	-- QuestFrame is Visible
   elseif (event=="GOSSIP_SHOW") then
      QTR_Gossip_Show();
   elseif (isImmersion() and event=="QUEST_ACCEPTED") then
      QTR_delayed3();
   end
   
end


function QTR_Gossip_Show()
   local Nazwa_NPC = GossipFrameNpcNameText:GetText();
   curr_hash = 0;

   if QTR_onDebug then
       print("Nome NPC: ", Nazwa_NPC or "Nessun nome");
   end

   if (Nazwa_NPC) then
       local Greeting_Text = GossipGreetingText:GetText();
       if QTR_onDebug then
           print("Testo di Greeting: ", Greeting_Text or "Nessun testo");
       end

       -- Durante QUEST_DETAIL, proviamo a recuperare il titolo della missione
       if event == "QUEST_DETAIL" then
           local questTitle = GetTitleText();
           local questText = GetQuestText();

           -- Prova a usare il QuestFrame
           if not questTitle or questTitle == "" then
               if QuestFrame and QuestFrame:IsVisible() then
                   questTitle = QuestFrame.title:GetText();
                   if QTR_onDebug then
                       print("QUEST_DETAIL: Titolo recuperato da QuestFrame: ", questTitle or "Nessun titolo");
                   end
               end
           end

           -- Prova a generare un hash con titolo e testo
           if questTitle and questText then
               local combinedText = questTitle .. " " .. questText;
               local hash = StringHash(combinedText);
               curr_hash = hash;

               if QTR_onDebug then
                   print("QUEST_DETAIL: Hash generato: ", hash);
               end

               if GS_Gossip[hash] then
                   if QTR_onDebug then
                       print("Traduzione trovata per QUEST_DETAIL. Hash: ", hash);
                   end
               else
                   if QTR_onDebug then
                       print("Traduzione mancante per QUEST_DETAIL. Hash: ", hash);
                   end
               end
           end
       end

       -- Continuazione normale della funzione Gossip
       if (string.find(Greeting_Text, " ") == nil) then
           local Czysty_Text = string.gsub(Greeting_Text, '\r', '');
           Czysty_Text = string.gsub(Czysty_Text, '\n', '$B');
           local Hash = StringHash(Czysty_Text);
           curr_hash = Hash;

           if QTR_onDebug then
               print("Hash generato: ", Hash);
           end

           if (GS_Gossip[Hash]) then
               if QTR_onDebug then
                   print("Traduzione trovata per il Gossip.");
               end
           else
               if QTR_onDebug then
                   print("Traduzione mancante per il Gossip.");
               end
           end
       end
   end
end


-- È stato aperto un QuestLog vuoto
function QTR_EmptyQuestLog()
   QTR_ToggleButton1:Hide();
end


-- QuestLogFrame o QuestMapDetailsScrollFrame o QuestGuru o finestra Immersione aperta
function QTR_QuestPrepare(zdarzenie)
   QTR_ToggleButton1:Show();        -- Mostra, perché potrebbe essere nascosto da un QuestLog vuoto
   if (isQuestGuru()) then
      if (QTR_PS["other1"]=="0") then       -- jest aktywny QuestGuru, ale nie zezwolono na tłumaczenie
         QTR_ToggleButton3:Hide();
         return;
      else   
         QTR_ToggleButton3:Show();
         if (QuestGuru:IsVisible() and (curr_trans=="0")) then
            QTR_Translate_Off(1);
            local questTitle, level, questTag, isHeader, isCollapsed, isComplete, isDaily, questID = GetQuestLogTitle(GetQuestLogSelection());
            if (QTR_quest_EN.id==questID) then
               return;
            end
         end
      end   
   end
   if (isImmersion()) then
      if (QTR_PS["other2"]=="0") then       -- jest aktywny Immersion, ale nie zezwolono na tłumaczenie
         QTR_ToggleButton4:Hide();
         return
      else
         QTR_ToggleButton4:Show();
         if (ImmersionContentFrame:IsVisible() and (curr_trans=="0")) then
            QTR_Translate_Off(1);
            return;
         end
      end      
   end
   q_ID = QTR_GetQuestID();
   str_ID = tostring(q_ID);
   QTR_quest_EN.id = q_ID;
   QTR_quest_LG.id = q_ID;
   if (isStoryline()) then
      QTR_ToggleButton5:Hide();
      if (QTR_PS["other3"]=="1") then
         if (q_ID>0) then
            QTR_ToggleButton5:Show();
         end
      else        -- nie zezwolono na tłumaczenie
         return
     end      
   end
   if (QTR_PS["control"]=="1") then         -- zapisuj kontrolnie treść oryginalnych questów EN
      QTR_quest_EN.title = GetTitleText();
      if (QTR_quest_EN.title=="") then
         QTR_quest_EN.title=GetQuestLogTitle(GetQuestLogSelection());
      end
      QTR_CONTROL[QTR_quest_EN.id.." TITLE"]=QTR_quest_EN.title;
      if (zdarzenie=="QUEST_DETAIL") then
         QTR_quest_EN.details = GetQuestText();
         QTR_quest_EN.objectives = GetObjectiveText();
         QTR_CONTROL[QTR_quest_EN.id.." DESCRIPTION"]=QTR_quest_EN.details;
         QTR_CONTROL[QTR_quest_EN.id.." OBJECTIVE"]=QTR_quest_EN.objectives;
      end
      if (zdarzenie=="QUEST_PROGRESS") then
         QTR_quest_EN.progress = GetProgressText();
         QTR_CONTROL[QTR_quest_EN.id.." PROGRESS"]=QTR_quest_EN.progress;
      end
      if (zdarzenie=="QUEST_COMPLETE") then
         QTR_quest_EN.completion = GetRewardText();
         QTR_CONTROL[QTR_quest_EN.id.." COMPLETE"]=QTR_quest_EN.completion;
      end
      QTR_CONTROL[QTR_quest_EN.id.." PLAYER"]=QTR_name..'@'..QTR_race..'@'..QTR_class;  -- zapisz dane gracza
   end
   if ( QTR_PS["active"]=="1" ) then	-- tłumaczenia włączone
      QTR_ToggleButton0:Enable();
      QTR_ToggleButton1:Enable();
      QTR_ToggleButton2:Enable();
      if (isImmersion()) then
         if (q_ID==0) then
            return;
         end   
         QTR_ToggleButton4:Enable();
      end
      curr_trans = "1";
      if ( QTR_QuestData[str_ID] ) then   -- wyświetlaj tylko, gdy istnieje tłumaczenie
         if (QTR_onDebug) then
            print('Znalazł tłumaczenie dla ID: '..str_ID);   
         end   
         QTR_quest_LG.title = QTR_ExpandUnitInfo(QTR_QuestData[str_ID]["Title"]);
         QTR_quest_EN.title = GetTitleText();
         if (QTR_quest_EN.title=="") then
            QTR_quest_EN.title=GetQuestLogTitle(GetQuestLogSelection());
         end
         QTR_quest_LG.details = QTR_ExpandUnitInfo(QTR_QuestData[str_ID]["Description"]);
         QTR_quest_LG.objectives = QTR_ExpandUnitInfo(QTR_QuestData[str_ID]["Objectives"]);
--         QTR_quest_EN.details = QuestLogQuestDescription:GetText();
--         QTR_quest_EN.objectives = QuestLogObjectivesText:GetText();
         if (zdarzenie=="QUEST_DETAIL") then
            QTR_quest_EN.details = GetQuestText();
            QTR_quest_EN.objectives = GetObjectiveText();
            QTR_quest_EN.itemchoose = QTR_MessOrig.itemchoose1;
            QTR_quest_LG.itemchoose = QTR_Messages.itemchoose1;
            QTR_quest_EN.itemreceive = QTR_MessOrig.itemreceiv1;
            QTR_quest_LG.itemreceive = QTR_Messages.itemreceiv1;
            if (strlen(QTR_quest_EN.details)>0 and strlen(QTR_quest_LG.details)==0) then
               QTR_MISSING[QTR_quest_EN.id.." DESCRIPTION"]=QTR_quest_EN.details;     -- save missing translation part
            end
            if (strlen(QTR_quest_EN.objectives)>0 and strlen(QTR_quest_LG.objectives)==0) then
               QTR_MISSING[QTR_quest_EN.id.." OBJECTIVE"]=QTR_quest_EN.objectives;    -- save missing translation part
            end
         else   
            if (QTR_quest_LG.details ~= QuestLogQuestDescription:GetText()) then
               QTR_quest_EN.details = QuestLogQuestDescription:GetText();
            end
            if (QTR_quest_LG.objectives ~= QuestLogObjectivesText:GetText()) then
               QTR_quest_EN.objectives = QuestLogObjectivesText:GetText();
            end
         end   
         if (zdarzenie=="QUEST_PROGRESS") then
            QTR_quest_EN.progress = GetProgressText();
            QTR_quest_LG.progress = QTR_ExpandUnitInfo(QTR_QuestData[str_ID]["Progress"]);
            if (strlen(QTR_quest_EN.progress)>0 and strlen(QTR_quest_LG.progress)==0) then
               QTR_MISSING[QTR_quest_EN.id.." PROGRESS"]=QTR_quest_EN.progress;     -- save missing translation part
            end
            if (strlen(QTR_quest_LG.progress)==0) then      -- treść jest pusta, a otworzono okienko Progress
               QTR_quest_LG.progress = QTR_ExpandUnitInfo('Stai andando bene, YOUR_NAME');
            end
         end
         if (zdarzenie=="QUEST_COMPLETE") then
            QTR_quest_EN.completion = GetRewardText();
            QTR_quest_LG.completion = QTR_ExpandUnitInfo(QTR_QuestData[str_ID]["Completion"]);
            QTR_quest_EN.itemchoose = QTR_MessOrig.itemchoose2;
            QTR_quest_LG.itemchoose = QTR_Messages.itemchoose2;
            QTR_quest_EN.itemreceive = QTR_MessOrig.itemreceiv2;
            QTR_quest_LG.itemreceive = QTR_Messages.itemreceiv2;
            if (strlen(QTR_quest_EN.completion)>0 and strlen(QTR_quest_LG.completion)==0) then
               QTR_MISSING[QTR_quest_EN.id.." COMPLETE"]=QTR_quest_EN.completion;     -- save missing translation part
            end
         end         
         QTR_ToggleButton0:SetText("Quest ID="..QTR_quest_LG.id.." ("..QTR_lang..")");
         QTR_ToggleButton1:SetText("Quest ID="..QTR_quest_LG.id.." ("..QTR_lang..")");
         QTR_ToggleButton2:SetText("Quest ID="..QTR_quest_LG.id.." ("..QTR_lang..")");
         if (isQuestGuru()) then
            QTR_ToggleButton3:SetText("Quest ID="..QTR_quest_LG.id.." ("..QTR_lang..")");
            QTR_ToggleButton3:Enable();
         end
         if (isImmersion()) then
            QTR_ToggleButton4:SetText("Quest ID="..QTR_quest_LG.id.." ("..QTR_lang..")");
            QTR_quest_EN.details = GetQuestText();
            QTR_quest_EN.progress = GetProgressText();
            QTR_quest_EN.completion = GetRewardText();
         end
         if (isStoryline() and Storyline_NPCFrame:IsVisible()) then
            QTR_ToggleButton5:SetText("Quest ID="..QTR_quest_LG.id.." ("..QTR_lang..")");
         end
         QTR_Translate_On(1);
      else	      -- nie ma przetłumaczonego takiego questu
         if (QTR_onDebug) then
            print('Nie znalazł tłumaczenia dla ID: '..str_ID);   
         end   
         QTR_ToggleButton0:Disable();
         QTR_ToggleButton1:Disable();
         QTR_ToggleButton2:Disable();
         if (isQuestGuru()) then
            QTR_ToggleButton3:Disable();
         end
         if (isImmersion()) then
            QTR_ToggleButton4:Disable();
         end
         if (isStoryline()) then
            QTR_ToggleButton5:Disable();
         end
         QTR_ToggleButton0:SetText("Quest ID="..str_ID);
         QTR_ToggleButton1:SetText("Quest ID="..str_ID);
         QTR_ToggleButton2:SetText("Quest ID="..str_ID);
         if (isQuestGuru()) then
            QTR_ToggleButton3:SetText("Quest ID="..str_ID);
         end
         if (isImmersion()) then
            if (q_ID==0) then
               if (ImmersionFrame.TitleButtons:IsVisible()) then
                  QTR_ToggleButton4:SetText("wybierz wpierw quest");
               end
            else
               QTR_ToggleButton4:SetText("Quest ID="..str_ID);
            end
         end
         if (isStoryline()) then
            QTR_ToggleButton5:SetText("Quest ID="..str_ID);
         end
         QTR_Translate_On(0);
         QTR_SaveQuest(zdarzenie);
      end -- jest przetłumaczony quest w bazie
   else	-- tłumaczenia wyłączone
      QTR_ToggleButton0:Disable();
      QTR_ToggleButton1:Disable();
      QTR_ToggleButton2:Disable();
--         if (isQuestGuru()) then
--            QTR_ToggleButton3:Disable();
--         end
--         if (isImmersion()) then
--            QTR_ToggleButton4:Disable();
--         end
      if ( QTR_QuestData[str_ID] ) then	-- ale jest tłumaczenie w bazie
         QTR_ToggleButton1:SetText("Quest ID="..str_ID.." (EN)");
         QTR_ToggleButton2:SetText("Quest ID="..str_ID.." (EN)");
         if (isQuestGuru()) then
            QTR_ToggleButton3:SetText("Quest ID="..str_ID.." (EN)");
         end
         if (isImmersion()) then
            QTR_ToggleButton4:SetText("Quest ID="..str_ID.." (EN)");
         end
         if (isStoryline()) then
            QTR_ToggleButton5:SetText("Quest ID="..str_ID.." (EN)");
         end
      else
         QTR_ToggleButton1:SetText("Quest ID="..str_ID);
         QTR_ToggleButton2:SetText("Quest ID="..str_ID);
         if (isQuestGuru()) then
            QTR_ToggleButton3:SetText("Quest ID="..str_ID);
         end
         if (isImmersion()) then
            QTR_ToggleButton4:SetText("Quest ID="..str_ID);
         end
         if (isStoryline()) then
            QTR_ToggleButton5:SetText("Quest ID="..str_ID);
         end
      end
   end	-- tłumaczenia są włączone
   if (QTR_PS["Reklama"]=="1") then
      QTR_SendReklama();
   end
end


-- wyświetla tłumaczenie
function QTR_Translate_On(typ)
   if (QTR_onDebug) then
      print('Visualizza la traduzione');   
   end   
   QuestInfoObjectivesHeader:SetFont(QTR_Font1, 18);
   QuestInfoObjectivesHeader:SetText(QTR_Messages.objectives); -- "Zadanie"

   QuestLogRewardTitleText:SetFont(QTR_Font1, 18);
   QuestLogRewardTitleText:SetText(QTR_Messages.rewards);      -- "Nagroda"
   QuestInfoRewardsFrame.Header:SetFont(QTR_Font1, 18);
   QuestInfoRewardsFrame.Header:SetText(QTR_Messages.rewards);  -- "Nagroda"
   
   QuestLogDescriptionTitle:SetFont(QTR_Font1, 18);
   QuestLogDescriptionTitle:SetText(QTR_Messages.details);     -- "Szczegóły"
   
   QuestProgressRequiredItemsText:SetFont(QTR_Font1, 18);
   QuestProgressRequiredItemsText:SetText(QTR_Messages.reqitems);
   
--   QuestInfoSpellObjectiveLearnLabel:SetFont(QTR_Font2, 13);
--   QuestInfoSpellObjectiveLearnLabel:SetText(QTR_Messages.learnspell);
--   QuestInfoXPFrame.ReceiveText:SetFont(QTR_Font2, 13);
--   QuestInfoXPFrame.ReceiveText:SetText(QTR_Messages.experience);
--   MapQuestInfoRewardsFrame.ItemChooseText:SetFont(QTR_Font2, 11);
--   MapQuestInfoRewardsFrame.ItemReceiveText:SetFont(QTR_Font2, 11);
--   MapQuestInfoRewardsFrame.ItemChooseText:SetText(QTR_Messages.itemchoose1);
--   MapQuestInfoRewardsFrame.ItemReceiveText:SetText(QTR_Messages.itemreceiv1);
   if (typ==1) then			-- pełne przełączenie (jest tłumaczenie)
      QuestLogItemChooseText:SetFont(QTR_Font2, 13);
      QuestLogItemChooseText:SetText(QTR_Messages.itemchoose1);
      QuestLogItemReceiveText:SetFont(QTR_Font2, 13);
      QuestLogItemReceiveText:SetText(QTR_Messages.itemreceiv1);
      numer_ID = QTR_quest_LG.id;
      str_ID = tostring(numer_ID);
      if (numer_ID>0 and QTR_QuestData[str_ID]) then	-- przywróć przetłumaczoną wersję napisów
         if (QTR_onDebug) then
            print('tłum.ID='..str_ID);   
         end   
         if (QTR_PS["transtitle"]=="1") then    -- wyświetl przetłumaczony tytuł
            QuestLogQuestTitle:SetFont(QTR_Font1, 18);
            QuestLogQuestTitle:SetText(QTR_quest_LG.title);
            QuestInfoTitleHeader:SetFont(QTR_Font1, 18);
            QuestInfoTitleHeader:SetText(QTR_quest_LG.title);
            QuestProgressTitleText:SetFont(QTR_Font1, 18);
            QuestProgressTitleText:SetText(QTR_quest_LG.title);
         end
         QTR_ToggleButton0:SetText("Quest ID="..QTR_quest_LG.id.." ("..QTR_lang..")");
         QTR_ToggleButton1:SetText("Quest ID="..QTR_quest_LG.id.." ("..QTR_lang..")");
         QTR_ToggleButton2:SetText("Quest ID="..QTR_quest_LG.id.." ("..QTR_lang..")");
         if (isQuestGuru()) then
            QTR_ToggleButton3:SetText("Quest ID="..QTR_quest_LG.id.." ("..QTR_lang..")");
         end
         if (isImmersion()) then
            QTR_ToggleButton4:SetText("Quest ID="..QTR_quest_LG.id.." ("..QTR_lang..")");
            if (not QTR_wait(0.2,QTR_Immersion)) then    -- wywołaj podmienianie danych po 0.2 sek
               -- opóźnienie 0.2 sek
            end
         end
         if (isStoryline() and Storyline_NPCFrame:IsVisible()) then
            QTR_ToggleButton5:SetText("Quest ID="..QTR_quest_LG.id.." ("..QTR_lang..")");
            QTR_Storyline(1);
         end
         QuestLogQuestDescription:SetFont(QTR_Font2, 13);
         QuestLogQuestDescription:SetText(QTR_quest_LG.details);
         QuestInfoDescriptionText:SetFont(QTR_Font2, 13);
         QuestInfoDescriptionText:SetText(QTR_quest_LG.details);
         QuestInfoObjectivesText:SetFont(QTR_Font2, 13);
         QuestInfoObjectivesText:SetText(QTR_quest_LG.objectives);
         
         QuestLogObjectivesText:SetFont(QTR_Font2, 13);
         QuestLogObjectivesText:SetText(QTR_quest_LG.objectives);
         
         QuestProgressText:SetFont(QTR_Font2, 13);
         QuestProgressText:SetText(QTR_quest_LG.progress);
         QuestInfoRewardText:SetFont(QTR_Font2, 13);
         QuestInfoRewardText:SetText(QTR_quest_LG.completion);
         
         QuestInfoRewardsFrame.ItemChooseText:SetFont(QTR_Font2, 13);
         QuestInfoRewardsFrame.ItemChooseText:SetText(QTR_quest_LG.itemchoose);
         QuestInfoRewardsFrame.ItemReceiveText:SetFont(QTR_Font2, 13);
         QuestInfoRewardsFrame.ItemReceiveText:SetText(QTR_quest_LG.itemreceive);
      end
   else
      if (curr_trans == "1") then
         QuestInfoRewardsFrame.ItemChooseText:SetText(QTR_Messages.itemchoose1);
         QuestInfoRewardsFrame.ItemReceiveText:SetText(QTR_Messages.itemreceiv1);
         if ((ImmersionFrame ~= nil ) and (ImmersionFrame.TalkBox:IsVisible() )) then
            if (not QTR_wait(0.2,QTR_Immersion_Static)) then
               -- podmiana tekstu z opóźnieniem 0.2 sek
            end
         end
      end
   end
end


-- wyświetla oryginalny tekst
function QTR_Translate_Off(typ)
   QuestInfoTitleHeader:SetFont(Original_Font1, 18);
   QuestInfoTitleHeader:SetText(QTR_quest_EN.title);
--   QuestProgressTitleText:SetText(QTR_quest_EN.title);        
--   QuestProgressTitleText:SetFont(Original_Font1, 18);
   
   QuestLogQuestTitle:SetFont(Original_Font1, 18);
   QuestLogQuestTitle:SetText(QTR_quest_EN.title);
   
   QuestInfoObjectivesHeader:SetFont(Original_Font1, 18);      -- Quest Objectives
   QuestInfoObjectivesHeader:SetText(QTR_MessOrig.objectives);

   QuestLogRewardTitleText:SetFont(Original_Font1, 18);        -- Reward
   QuestLogRewardTitleText:SetText(QTR_MessOrig.rewards);
   QuestInfoRewardsFrame.Header:SetFont(Original_Font1, 18);   -- Reward
   QuestInfoRewardsFrame.Header:SetText(QTR_MessOrig.rewards);
   
   QuestLogDescriptionTitle:SetFont(Original_Font1, 18);       -- Description
   QuestLogDescriptionTitle:SetText(QTR_MessOrig.details);
   
   QuestProgressRequiredItemsText:SetFont(Original_Font1, 18);
   QuestProgressRequiredItemsText:SetText(QTR_MessOrig.reqitems);
   
--   MapQuestInfoRewardsFrame.ItemReceiveText:SetFont(Original_Font2, 11);
--   MapQuestInfoRewardsFrame.ItemChooseText:SetFont(Original_Font2, 11);
   QuestInfoSpellObjectiveLearnLabel:SetFont(Original_Font2, 13);
   QuestInfoSpellObjectiveLearnLabel:SetText(QTR_MessOrig.learnspell);
   QuestInfoXPFrame.ReceiveText:SetFont(Original_Font2, 13);
   QuestInfoXPFrame.ReceiveText:SetText(QTR_MessOrig.experience);
   if (typ==1) then			-- pełne przełączenie (jest tłumaczenie)
      QuestLogItemChooseText:SetFont(Original_Font2, 13);
      QuestLogItemChooseText:SetText(QTR_MessOrig.itemchoose1);
      QuestLogItemReceiveText:SetFont(Original_Font2, 13);
      QuestLogItemReceiveText:SetText(QTR_MessOrig.itemreceiv1);
--      MapQuestInfoRewardsFrame.ItemReceiveText:SetText(QTR_MessOrig.itemreceiv1);
--      MapQuestInfoRewardsFrame.ItemChooseText:SetText(QTR_MessOrig.itemreceiv1);
      numer_ID = QTR_quest_EN.id;
      if (numer_ID>0 and QTR_QuestData[str_ID]) then	-- przywróć oryginalną wersję napisów
         QTR_ToggleButton0:SetText("Quest ID="..QTR_quest_EN.id.." (EN)");
         QTR_ToggleButton1:SetText("Quest ID="..QTR_quest_EN.id.." (EN)");
         QTR_ToggleButton2:SetText("Quest ID="..QTR_quest_EN.id.." (EN)");
         if (QuestGuru ~= nil ) then
            QTR_ToggleButton3:SetText("Quest ID="..QTR_quest_EN.id.." (EN)");
         end
         if (ImmersionFrame ~= nil ) then
            QTR_ToggleButton4:SetText("Quest ID="..QTR_quest_EN.id.." (EN)");
            QTR_Immersion_OFF();
            ImmersionFrame.TalkBox.TextFrame.Text:RepeatTexts();   --reload text
         end
         if (isStoryline()) then
            QTR_ToggleButton5:SetText("Quest ID="..QTR_quest_EN.id.." (EN)");
            QTR_Storyline_OFF(1);
         end
         QuestLogQuestDescription:SetFont(Original_Font2, 13);
         QuestLogQuestDescription:SetText(QTR_quest_EN.details);
         QuestInfoDescriptionText:SetFont(Original_Font2, 13);
         QuestInfoDescriptionText:SetText(QTR_quest_EN.details);
         QuestInfoObjectivesText:SetFont(Original_Font2, 13);
         QuestInfoObjectivesText:SetText(QTR_quest_EN.objectives);
         
         QuestLogObjectivesText:SetFont(Original_Font2, 13);
         QuestLogObjectivesText:SetText(QTR_quest_EN.objectives);
         
         QuestProgressText:SetFont(Original_Font2, 13);
         QuestProgressText:SetText(QTR_quest_EN.progress);
         QuestInfoRewardText:SetFont(Original_Font2, 13);
         QuestInfoRewardText:SetText(QTR_quest_EN.completion);
         
         QuestInfoRewardsFrame.ItemChooseText:SetFont(Original_Font2, 13);
         QuestInfoRewardsFrame.ItemChooseText:SetText(QTR_quest_EN.itemchoose);
         QuestInfoRewardsFrame.ItemReceiveText:SetFont(Original_Font2, 13);
         QuestInfoRewardsFrame.ItemReceiveText:SetText(QTR_quest_EN.itemreceive);
      end
   else   
      if (curr_trans == "0") then
         if ((ImmersionFrame ~= nil ) and (ImmersionFrame.TalkBox:IsVisible() )) then
            if (not QTR_wait(0.2,QTR_Immersion_OFF_Static)) then
               -- podmiana tekstu z opóźnieniem 0.2 sek
            end
         end
      end
   end
end


function QTR_delayed3()
   QTR_ToggleButton4:SetText("wybierz wpierw quest");
   QTR_ToggleButton4:Hide();
   if (not QTR_wait(1,QTR_delayed4)) then
   ---
   end
end


function QTR_delayed4()
   if (ImmersionFrame.TitleButtons:IsVisible()) then
      if (ImmersionFrame.TitleButtons.Buttons[1] ~= nil ) then
         ImmersionFrame.TitleButtons.Buttons[1]:HookScript("OnClick", function() QTR_PrepareDelay(1) end);
      end
      if (ImmersionFrame.TitleButtons.Buttons[2] ~= nil ) then
         ImmersionFrame.TitleButtons.Buttons[2]:HookScript("OnClick", function() QTR_PrepareDelay(1) end);
      end
      if (ImmersionFrame.TitleButtons.Buttons[3] ~= nil ) then
         ImmersionFrame.TitleButtons.Buttons[3]:HookScript("OnClick", function() QTR_PrepareDelay(1) end);
      end   
      if (ImmersionFrame.TitleButtons.Buttons[4] ~= nil ) then
         ImmersionFrame.TitleButtons.Buttons[4]:HookScript("OnClick", function() QTR_PrepareDelay(1) end);
      end
      if (ImmersionFrame.TitleButtons.Buttons[5] ~= nil ) then
         ImmersionFrame.TitleButtons.Buttons[5]:HookScript("OnClick", function() QTR_PrepareDelay(1) end);
      end
   end
   QTR_QuestPrepare('');
end;      


function QTR_PrepareDelay(czas)     -- wywoływane po kliknięciu na nazwę questu z listy NPC
   if (czas==1) then
      if (not QTR_wait(1,QTR_PrepareReload)) then
      ---
      end
   end
   if (czas==3) then
      if (not QTR_wait(3,QTR_PrepareReload)) then
      ---
      end
   end
end;      


function QTR_PrepareReload()
   QTR_QuestPrepare('');
end;      


function QTR_Prepare1sek()
   if (not QTR_wait(0.1,QTR_PrepareReload)) then
   ---
   end
end;      


function QTR_Immersion()   -- wywoływanie tłumaczenia z opóźnieniem 0.2 sek
  ImmersionContentFrame.ObjectivesText:SetFont(QTR_Font2, 14);
  ImmersionContentFrame.ObjectivesText:SetText(QTR_quest_LG.objectives);
  ImmersionFrame.TalkBox.NameFrame.Name:SetFont(QTR_Font1, 20);
  ImmersionFrame.TalkBox.NameFrame.Name:SetText(QTR_quest_LG.title);
  ImmersionFrame.TalkBox.TextFrame.Text:SetFont(QTR_Font2, 14);
  if (strlen(QTR_quest_EN.details)>0) then                                    -- Dettagli
     ImmersionFrame.TalkBox.TextFrame.Text:SetText(QTR_quest_LG.details);
  elseif (strlen(QTR_quest_EN.completion)>0) then
     ImmersionFrame.TalkBox.TextFrame.Text:SetText(QTR_quest_LG.completion);
  else
     ImmersionFrame.TalkBox.TextFrame.Text:SetText(QTR_quest_LG.progress);
  end
  QTR_Immersion_Static();        -- altri dati statici
end


function QTR_Immersion_Static() 
  ImmersionContentFrame.ObjectivesHeader:SetFont(QTR_Font1, 18);
  ImmersionContentFrame.ObjectivesHeader:SetText(QTR_Messages.objectives);  -- "Compito"
  ImmersionContentFrame.RewardsFrame.Header:SetFont(QTR_Font1, 18);
  ImmersionContentFrame.RewardsFrame.Header:SetText(QTR_Messages.rewards);  -- "Ricompensa"
  ImmersionContentFrame.RewardsFrame.ItemChooseText:SetFont(QTR_Font2, 13);
  ImmersionContentFrame.RewardsFrame.ItemChooseText:SetText(QTR_Messages.itemchoose1); -- "Puoi scegliere un premio:"
  ImmersionContentFrame.RewardsFrame.ItemReceiveText:SetFont(QTR_Font2, 13);
  ImmersionContentFrame.RewardsFrame.ItemReceiveText:SetText(QTR_Messages.itemreceiv1); -- "Riceverai come ricompensa:"
  ImmersionContentFrame.RewardsFrame.XPFrame.ReceiveText:SetFont(QTR_Font2, 13);
  ImmersionContentFrame.RewardsFrame.XPFrame.ReceiveText:SetText(QTR_Messages.experience);  -- "esperienza"
  ImmersionFrame.TalkBox.Elements.Progress.ReqText:SetFont(QTR_Font1, 18);
  ImmersionFrame.TalkBox.Elements.Progress.ReqText:SetText(QTR_Messages.reqitems);  -- "Articoli richiesti:"
end


function QTR_Immersion_OFF()   -- sviluppare l'originale
  ImmersionContentFrame.ObjectivesText:SetFont(Original_Font2, 14);
  ImmersionContentFrame.ObjectivesText:SetText(QTR_quest_EN.objectives);
  ImmersionFrame.TalkBox.NameFrame.Name:SetFont(Original_Font1, 20);
  ImmersionFrame.TalkBox.NameFrame.Name:SetText(QTR_quest_EN.title);
  ImmersionFrame.TalkBox.TextFrame.Text:SetFont(Original_Font2, 14);
  if (strlen(QTR_quest_EN.details)>0) then                                    -- ripristinare il testo originale
     ImmersionFrame.TalkBox.TextFrame.Text:SetText(QTR_quest_EN.details);
  elseif (strlen(QTR_quest_EN.progress)>0) then
     ImmersionFrame.TalkBox.TextFrame.Text:SetText(QTR_quest_EN.progress);
  else
     ImmersionFrame.TalkBox.TextFrame.Text:SetText(QTR_quest_EN.completion);
  end
  QTR_Immersion_OFF_Static();       -- altri dati statici
end


function QTR_Immersion_OFF_Static()
  ImmersionContentFrame.ObjectivesHeader:SetFont(Original_Font1, 18);
  ImmersionContentFrame.ObjectivesHeader:SetText(QTR_MessOrig.objectives);  -- "Compito"
  ImmersionContentFrame.RewardsFrame.Header:SetFont(Original_Font1, 18);
  ImmersionContentFrame.RewardsFrame.Header:SetText(QTR_MessOrig.rewards);  -- "Ricompensa"
  ImmersionContentFrame.RewardsFrame.ItemChooseText:SetFont(Original_Font2, 13);
  ImmersionContentFrame.RewardsFrame.ItemChooseText:SetText(QTR_MessOrig.itemchoose1); -- "Puoi scegliere un premio:"
  ImmersionContentFrame.RewardsFrame.ItemReceiveText:SetFont(Original_Font2, 13);
  ImmersionContentFrame.RewardsFrame.ItemReceiveText:SetText(QTR_MessOrig.itemreceiv1); -- "Riceverai come ricompensa:"
  ImmersionContentFrame.RewardsFrame.XPFrame.ReceiveText:SetFont(Original_Font2, 13);
  ImmersionContentFrame.RewardsFrame.XPFrame.ReceiveText:SetText(QTR_MessOrig.experience);  -- "esperienza"
  ImmersionFrame.TalkBox.Elements.Progress.ReqText:SetFont(Original_Font1, 18);
  ImmersionFrame.TalkBox.Elements.Progress.ReqText:SetText(QTR_MessOrig.reqitems);  -- "Articoli richiesti:"
end


function QTR_Storyline_Delay()
   QTR_Storyline(1);
end


function QTR_Storyline_Quest()
   if (QTR_PS["active"]=="1" and QTR_PS["other3"]=="1" and Storyline_NPCFrameTitle:IsVisible()) then
      QTR_QuestPrepare('');
   end
end


function QTR_Storyline_Hide()
   if (QTR_PS["active"]=="1" and QTR_PS["other3"]=="1") then
      QTR_ToggleButton5:Hide();
   end
end


function QTR_Storyline_Objectives()
   if (QTR_onDebug) then
      print("QTR_ST: objectives");
   end
   if (QTR_PS["active"]=="1" and QTR_PS["other3"]=="1" and QTR_quest_LG.id>0) then
      local string_ID= tostring(QTR_quest_LG.id);
      Storyline_NPCFrameObjectivesContent.Title:SetText('Zadanie');
      if (QTR_QuestData[string_ID] ) then
         Storyline_NPCFrameObjectivesContent.Objectives:SetText(QTR_ExpandUnitInfo(QTR_QuestData[string_ID]["Objectives"]));
         Storyline_NPCFrameObjectivesContent.Objectives:SetFont(QTR_Font2, 13);
      end   
   end
end


function QTR_Storyline_Rewards()
   if (QTR_onDebug) then
      print("QTR_ST: rewards");
   end
   if (QTR_PS["active"]=="1" and QTR_PS["other3"]=="1") then
      Storyline_NPCFrameRewards.Content.Title:SetText('Nagroda');
   end
end


function QTR_Storyline(nr)
   if (QTR_onDebug) then
      print('QTR_ST: Podmieniam quest '..QTR_quest_LG.id);
   end
   if (QTR_PS["transtitle"]=="1") then
      Storyline_NPCFrameTitle:SetText(QTR_quest_LG.title);
      Storyline_NPCFrameTitle:SetFont(QTR_Font2, 18);
   end
   local string_ID= tostring(QTR_quest_LG.id);
   local texts = { "" };
   if ((Storyline_NPCFrameChat.event ~= nil) and (QTR_QuestData[string_ID] ~= nil))then
      local event = Storyline_NPCFrameChat.event;
      if (event=="QUEST_DETAIL") then
     	   texts = { strsplit("\n", QTR_ExpandUnitInfo(QTR_QuestData[string_ID]["Description"])) };
      end   
      if (event=="QUEST_PROGRESS") then
     	   texts = { strsplit("\n", QTR_ExpandUnitInfo(QTR_QuestData[string_ID]["Progress"])) };
      end   
      if (event=="QUEST_COMPLETE") then
     	   texts = { strsplit("\n", QTR_ExpandUnitInfo(QTR_QuestData[string_ID]["Completion"])) };
      end   
   end
   local ileOry = #Storyline_NPCFrameChat.texts;
   local indeks = 0;
   for i=1,#texts do
      if texts[i]:len() > 0 then
         if (indeks<ileOry) then
            indeks=indeks+1;
            Storyline_NPCFrameChat.texts[indeks]=texts[i];
         end
      end
   end
   Storyline_NPCFrameChatText:SetFont(QTR_Font2, 16);
   if (nr==1) then      -- Reload text
      Storyline_NPCFrameObjectivesContent:Hide();
      Storyline_NPCFrame.chat.currentIndex = 0;
      Storyline_API.playNext(Storyline_NPCFrameModelsYou);  -- reload
   end
end


function QTR_Storyline_OFF(nr)
   if (QTR_onDebug) then
      print('QTR_SToff: Sto riportando indietro la ricerca '..QTR_quest_EN.id);
   end
   if (QTR_PS["transtitle"]=="1") then
      Storyline_NPCFrameTitle:SetText(QTR_quest_EN.title);
      Storyline_NPCFrameTitle:SetFont(Original_Font2, 18);
   end
   local string_ID= tostring(QTR_quest_EN.id);
   local texts = { "" };
   if ((Storyline_NPCFrameChat.event ~= nil) and (QTR_QuestData[string_ID] ~= nil))then
      local event = Storyline_NPCFrameChat.event;
      if (event=="QUEST_DETAIL") then
     	   texts = { strsplit("\n", GetQuestText()) };
      end   
      if (event=="QUEST_PROGRESS") then
     	   texts = { strsplit("\n", GetProgressText()) };
      end   
      if (event=="QUEST_COMPLETE") then
     	   texts = { strsplit("\n", GetRewardText()) };
      end   
   end
   local ileOry = #Storyline_NPCFrameChat.texts;
   local indeks = 0;
   for i=1,#texts do
      if texts[i]:len() > 0 then
         if (indeks<ileOry) then
            indeks=indeks+1;
            Storyline_NPCFrameChat.texts[indeks]=texts[i];
         end
      end
   end
   Storyline_NPCFrameChatText:SetFont(Original_Font2, 16);
   if (nr==1) then      -- Reload text
      Storyline_NPCFrameObjectivesContent:Hide();
      Storyline_NPCFrame.chat.currentIndex = 0;
      Storyline_API.playNext(Storyline_NPCFrameModelsYou);  -- reload
   end
end


-- sostituisce i caratteri speciali nel testo
function QTR_ExpandUnitInfo(msg)
   msg = string.gsub(msg, "NEW_LINE", "\n");
   msg = string.gsub(msg, "YOUR_NAME1", QTR_PC["name1"]);
   msg = string.gsub(msg, "YOUR_NAME2", QTR_PC["name2"]);
   msg = string.gsub(msg, "YOUR_NAME3", QTR_PC["name3"]);
   msg = string.gsub(msg, "YOUR_NAME4", QTR_PC["name4"]);
   msg = string.gsub(msg, "YOUR_NAME5", QTR_PC["name5"]);
   msg = string.gsub(msg, "YOUR_NAME6", QTR_PC["name6"]);
   msg = string.gsub(msg, "YOUR_NAME7", QTR_PC["name7"]);
   msg = string.gsub(msg, "YOUR_NAME", QTR_name);
   
-- supporta ancora YOUR_GENDER (x; y)
   local nr_1, nr_2, nr_3 = 0;
   local QTR_forma = "";
   local nr_poz = string.find(msg, "YOUR_GENDER");    -- quando non ha trovato, c'è: nill
   while (nr_poz and nr_poz>0) do
      nr_1 = nr_poz + 1;   
      while (string.sub(msg, nr_1, nr_1) ~= "(") do
         nr_1 = nr_1 + 1;
      end
      if (string.sub(msg, nr_1, nr_1) == "(") then
         nr_2 =  nr_1 + 1;
         while (string.sub(msg, nr_2, nr_2) ~= ";") do
            nr_2 = nr_2 + 1;
         end
         if (string.sub(msg, nr_2, nr_2) == ";") then
            nr_3 = nr_2 + 1;
            while (string.sub(msg, nr_3, nr_3) ~= ")") do
               nr_3 = nr_3 + 1;
            end
            if (string.sub(msg, nr_3, nr_3) == ")") then
               if (QTR_sex==3) then        -- forma femminile
                  QTR_forma = string.sub(msg,nr_2+1,nr_3-1);
               else                        -- forma maschile
                  QTR_forma = string.sub(msg,nr_1+1,nr_2-1);
               end
               msg = string.sub(msg,1,nr_poz-1) .. QTR_forma .. string.sub(msg,nr_3+1);
            end   
         end
      end
      nr_poz = string.find(msg, "YOUR_GENDER");
   end

-- supporta ancora NPC_GENDER (x; y)
   local nr_1, nr_2, nr_3 = 0;
   local QTR_forma = "";
   local nr_poz = string.find(msg, "NPC_GENDER");    -- quando non ha trovato, c'è: nill
   while (nr_poz and nr_poz>0) do
      nr_1 = nr_poz + 1;   
      while (string.sub(msg, nr_1, nr_1) ~= "(") do
         nr_1 = nr_1 + 1;
      end
      if (string.sub(msg, nr_1, nr_1) == "(") then
         nr_2 =  nr_1 + 1;
         while (string.sub(msg, nr_2, nr_2) ~= ";") do
            nr_2 = nr_2 + 1;
         end
         if (string.sub(msg, nr_2, nr_2) == ";") then
            nr_3 = nr_2 + 1;
            while (string.sub(msg, nr_3, nr_3) ~= ")") do
               nr_3 = nr_3 + 1;
            end
            if (string.sub(msg, nr_3, nr_3) == ")") then
               if (QTR_sex==3) then        -- forma femminile
                  QTR_forma = string.sub(msg,nr_2+1,nr_3-1);
               else                        -- forma maschile
                  QTR_forma = string.sub(msg,nr_1+1,nr_2-1);
               end
               msg = string.sub(msg,1,nr_poz-1) .. QTR_forma .. string.sub(msg,nr_3+1);
            end   
         end
      end
      nr_poz = string.find(msg, "NPC_GENDER");
   end

   if (QTR_sex==3) then        -- płeć żeńska
      msg = string.gsub(msg, "YOUR_CLASS1", player_class.M2);          -- Denominatore (chi, cosa?)
      msg = string.gsub(msg, "YOUR_CLASS2", player_class.D2);          -- Genitivo (chi, cosa?)
      msg = string.gsub(msg, "YOUR_CLASS3", player_class.C2);          -- Incontri (a chi, perché?)
      msg = string.gsub(msg, "YOUR_CLASS4", player_class.B2);          -- Accusativo (chi, cosa?)
      msg = string.gsub(msg, "YOUR_CLASS5", player_class.N2);          -- Strumenti (con chi, con cosa?)
      msg = string.gsub(msg, "YOUR_CLASS6", player_class.K2);          -- Locativo (su chi, su cosa?)
      msg = string.gsub(msg, "YOUR_CLASS7", player_class.W2);          -- vocativo
      msg = string.gsub(msg, "YOUR_RACE1", player_race.M2);            -- Denominatore (chi, cosa?)
      msg = string.gsub(msg, "YOUR_RACE2", player_race.D2);            -- Dopełniacz (kogo, czego?)
      msg = string.gsub(msg, "YOUR_RACE3", player_race.C2);            -- Celownik (komu, czemu?)
      msg = string.gsub(msg, "YOUR_RACE4", player_race.B2);            -- Accusativo (chi, cosa?)
      msg = string.gsub(msg, "YOUR_RACE5", player_race.N2);            -- Toolbox (chi, cosa?)
      msg = string.gsub(msg, "YOUR_RACE6", player_race.K2);            -- 
      msg = string.gsub(msg, "YOUR_RACE7", player_race.W2);            -- 
      msg = string.gsub(msg, "YOUR_RACE YOUR_CLASS", "YOUR_RACE "..player_class.M2);     -- Denominatore (chi, cosa?)
      msg = string.gsub(msg, "ą YOUR_RACE", "ą "..player_race.N2);              -- Toolbox (chi, cosa?)
      msg = string.gsub(msg, " jesteś YOUR_RACE", " jesteś "..player_race.N2);    -- Toolbox (chi, cosa?)
      msg = string.gsub(msg, "YOUR_RACE", player_race.W2);                        -- 
      msg = string.gsub(msg, "ą YOUR_CLASS", "ą "..player_class.N2);            -- Toolbox (chi, cosa?)
      msg = string.gsub(msg, "esteś YOUR_CLASS", "esteś "..player_class.N2);      -- Toolbox (chi, cosa?)
      msg = string.gsub(msg, " z Ciebie YOUR_CLASS", " z Ciebie "..player_class.M2);    -- Denominatore (chi, cosa?)
      msg = string.gsub(msg, " kolejny YOUR_CLASS do ", " kolejny "..player_class.M2.." do ");   -- Denominatore (chi, cosa?)
      msg = string.gsub(msg, " taki YOUR_CLASS", " taki "..player_class.M2);      -- Denominatore (chi, cosa?)
      msg = string.gsub(msg, "ako YOUR_CLASS", "ako "..player_class.M2);          -- Denominatore (chi, cosa?)
      msg = string.gsub(msg, " co sprowadza YOUR_CLASS", " co sprowadza "..player_class.B2);     -- Accusativo (chi, cosa?)
      msg = string.gsub(msg, " będę miał YOUR_CLASS", " będę miał "..player_class.B2);  -- Accusativo (chi, cosa?)
      msg = string.gsub(msg, "YOUR_CLASS taki jak ", player_class.B2.." taki jak ");    -- Accusativo (chi, cosa?)
      msg = string.gsub(msg, " jak na YOUR_CLASS", " jak na "..player_class.B2);        -- Accusativo (chi, cosa?)
      msg = string.gsub(msg, "YOUR_CLASS", player_class.W2);                      -- 
   else                    -- genere maschile
      msg = string.gsub(msg, "YOUR_CLASS1", player_class.M1);          -- Denominatore (chi, cosa?)
      msg = string.gsub(msg, "YOUR_CLASS2", player_class.D1);          -- Dopełniacz (kogo, czego?)
      msg = string.gsub(msg, "YOUR_CLASS3", player_class.C1);          -- Incontri (a chi, perché?)
      msg = string.gsub(msg, "YOUR_CLASS4", player_class.B1);          -- Accusativo (chi, cosa?)
      msg = string.gsub(msg, "YOUR_CLASS5", player_class.N1);          -- Strumenti (con chi, con cosa?)
      msg = string.gsub(msg, "YOUR_CLASS6", player_class.K1);          -- Locativo (su chi, su cosa?)
      msg = string.gsub(msg, "YOUR_CLASS7", player_class.W1);          -- 
      msg = string.gsub(msg, "YOUR_RACE1", player_race.M1);            -- Denominatore (chi, cosa?)
      msg = string.gsub(msg, "YOUR_RACE2", player_race.D1);            -- Dopełniacz (kogo, czego?)
      msg = string.gsub(msg, "YOUR_RACE3", player_race.C1);            -- 
      msg = string.gsub(msg, "YOUR_RACE4", player_race.B1);            -- Accusativo (chi, cosa?)
      msg = string.gsub(msg, "YOUR_RACE5", player_race.N1);            -- Toolbox (chi, cosa?)
      msg = string.gsub(msg, "YOUR_RACE6", player_race.K1);            -- 
      msg = string.gsub(msg, "YOUR_RACE7", player_race.W1);            -- 
      msg = string.gsub(msg, "YOUR_RACE YOUR_CLASS", "YOUR_RACE "..player_class.M1);     -- Denominatore (chi, cosa?)
      msg = string.gsub(msg, "ym YOUR_RACE", "ym "..player_race.N1);              -- Toolbox (chi, cosa?)
      msg = string.gsub(msg, " jesteś YOUR_RACE", " jesteś "..player_race.N1);    -- Toolbox (chi, cosa?)
      msg = string.gsub(msg, "YOUR_RACE", player_race.W1);                        -- 
      msg = string.gsub(msg, "ym YOUR_CLASS", "ym "..player_class.N1);            -- Toolbox (chi, cosa?)
      msg = string.gsub(msg, "esteś YOUR_CLASS", "esteś "..player_class.N1);      -- Toolbox (chi, cosa?)
      msg = string.gsub(msg, " z Ciebie YOUR_CLASS", " z Ciebie "..player_class.M1);    -- Denominatore (chi, cosa?)
      msg = string.gsub(msg, " kolejny YOUR_CLASS do ", " kolejny "..player_class.M1.." do ");   -- Denominatore (chi, cosa?)
      msg = string.gsub(msg, " taki YOUR_CLASS", " taki "..player_class.M1);      -- Denominatore (chi, cosa?)
      msg = string.gsub(msg, "ako YOUR_CLASS", "ako "..player_class.M1);          -- Denominatore (chi, cosa?)
      msg = string.gsub(msg, " co sprowadza YOUR_CLASS", " co sprowadza "..player_class.B1);     -- Accusativo (chi, cosa?)
      msg = string.gsub(msg, " będę miał YOUR_CLASS", " będę miał "..player_class.B1);  -- Accusativo (chi, cosa?)
      msg = string.gsub(msg, "ego YOUR_CLASS", "ego "..player_class.B1);                -- Accusativo (chi, cosa?)
      msg = string.gsub(msg, "YOUR_CLASS taki jak ", player_class.B1.." taki jak ");    -- Accusativo (chi, cosa?)
      msg = string.gsub(msg, " jak na YOUR_CLASS", " jak na "..player_class.B1);        -- Accusativo (chi, cosa?)
      msg = string.gsub(msg, "YOUR_CLASS", player_class.W1);                      -- 
   end
   
   return msg;
end

