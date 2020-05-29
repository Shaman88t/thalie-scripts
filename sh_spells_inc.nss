//#include "sh_classes_const"
/*Nastavit bChange CL na FALSE, pokud nechceme omezovat podle caster level targetu*/
int GetThalieCaster(object oCaster,object oTarget,int iCasterLevel,int bChangeCL = TRUE,string params = "")
{
    int iModifiedCasterLevel =iCasterLevel;                                   //zustalo po zruseni dobrodruha kvuli proměnným
    if (GetLevelByClass(47,oCaster)>0)  //CLASS_TYPE_EXORCISTA
    {
         iModifiedCasterLevel+= GetLevelByClass(47,oCaster);
    }


    /* Underdark penalty */
    /* UNDERDARK_SETTING == KU_AREA_UNDERDARK */
    if(GetLocalInt( oCaster, "UNDERDARK_SETTING") == 300 ) {
        iModifiedCasterLevel+= -5;
    }
    //Pan smrti
    int iPaleMasterLevel = GetLevelByClass(CLASS_TYPE_PALE_MASTER,oCaster);
    if (iPaleMasterLevel>0)
    {
        int iIsNecro = FALSE;
        string sSchool = Get2DAString("spells","School",GetSpellId());
        if (sSchool=="Necromancy")
        {
            iIsNecro = TRUE;
            iModifiedCasterLevel+= iPaleMasterLevel;
        }
        if (GetHasFeat(FEAT_TOUGH_AS_BONE,oCaster))
        {
            if (iIsNecro==FALSE)
            {
                iModifiedCasterLevel = 1; //Tvrdost kosti - u jinych nez nekromancie nastavi level sesilatele na 1
            }
        }
    }

    /* For boost spells always reduce caster level. Cannot be higher than caster
       level*/
    if (bChangeCL)
    {
         int iHD = GetHitDice(oTarget);
         if (iModifiedCasterLevel>iHD) iModifiedCasterLevel=iHD;
    }

    return iModifiedCasterLevel;
}

int GetThalieSpellDCBonus(object oPCNPC)
{
    int iBonus = 0;
    //Epic DC bonus - +1 za kazde 2 lvly nad epic
    int iClass = GetLastSpellCastClass();
    switch(iClass) {
      case CLASS_TYPE_SORCERER: //CLASS_TYPE_SORCERER
      case CLASS_TYPE_WIZARD:  //CLASS_TYPE_WIZARD
      case CLASS_TYPE_CLERIC: //CLASS_TYPE_CLERIC
      case CLASS_TYPE_DRUID: //CLASS_TYPE_DRUID
      case CLASS_TYPE_BARD: //CLASS_TYPE_BARD
        if(GetLevelByClass(iClass,oPCNPC) >= 21)
          iBonus += (GetLevelByClass(iClass,oPCNPC)-19)/2;
        break;
      default: //nothing
        break;
    }


    return iBonus;
}
// nCasterLevel = GetThalieCaster(OBJECT_SELF,oTarget,nCasterLevel);
//+GetThalieSpellDCBonus(OBJECT_SELF)
// nCasterLevel = GetThalieCaster(OBJECT_SELF,oTarget,nCasterLevel,FALSE);

int GetThalieEpicSpellDCBonus(object oPC)
{
    int iHD = GetHitDice(oPC);
    return iHD / 3 +1;
}
