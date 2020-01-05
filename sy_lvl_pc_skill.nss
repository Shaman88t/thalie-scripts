/*
    -script ma za ulohu ulozit hodnotu hracovych skilov do lokalnych premennych
     na hracovi
    -po naklikani levelu sa tieto premenne testuju a ak sa najde podvod v stackovani
     skillpointov hracovi sa da relevel
*/

void main()
{
    //hrac ktory prave vedie dialog s majstrom remesla
    object oPC = GetPCSpeaker();

    //ulozim info o vyske skiloch pred levelupom na hraca
    int nLoop, nSkill;
    for (nLoop=0;nLoop<27;nLoop++)
    {
        nSkill = GetSkillRank(nLoop, oPC, TRUE);
        SetLocalInt(oPC, "sy_skill"+IntToString(nLoop), nSkill);
    }

    //ulozim aj info o leveloch postavy pred levelupom na hraca
    SetLocalInt(oPC, "sy_class1_lvl", GetLevelByPosition(1, oPC));

    //ulozim ake povolanie je povolene dat si - zavisi od majstra a jeho povolania
    SetLocalInt(oPC, "sy_class_mistra", GetClassByPosition(1, OBJECT_SELF));

    object oTrainer = OBJECT_SELF;

    SetLocalObject(oPC, "JA_LVL_TRAINER", oTrainer);

    //informativna sprava pre DEBUG
    AssignCommand(oTrainer ,SpeakString("Muzeme zacit s treninkem. Pozorne mi poslouchej, nebudu to opakovat! Jasny?!"));



    //oznacim hraca ako povoleneho naklikat si level
    SetLocalInt(oPC, "sy_allowlvl", 1);
}
