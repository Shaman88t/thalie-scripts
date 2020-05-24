//::///////////////////////////////////////////////
//:: Polymorph Self
//:: NW_S0_PolySelf.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The PC is able to changed their form to one of
    several forms.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 21, 2002
//:://////////////////////////////////////////////

#include "x2_inc_spellhook"
    #include "X0_I0_SPELLS"
void main()
{

/*
  Spellcast Hook Code
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/
    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

    //Declare major varia
    object oTarget = GetSpellTargetObject();
//    effect  eV        = EffectVisualEffect(VFX_IMP_HEAD_ODD);
//    effect   eImpact     = EffectVisualEffect(VFX_FNF_DISPEL_DISJUNCTION);
//    spellsDispelMagic(oTarget, 30, eV, eImpact, FALSE,TRUE);
    int nSpell = GetSpellId();

    effect eVis = EffectVisualEffect(VFX_IMP_POLYMORPH);
    effect ePoly;
    int nPoly;
    int nMetaMagic = GetMetaMagicFeat();
    int nDuration = GetCasterLevel(OBJECT_SELF);
    nDuration = GetThalieCaster(OBJECT_SELF,oTarget,nDuration,FALSE);
    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2; //Duration is +100%
    }
    if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_TRANSMUTATION))
    {
        //Determine Polymorph subradial type
        if(nSpell == 387)
        {
            nPoly = 108;
        }
        else if (nSpell == 388)
        {
            nPoly = 109;
        }
        else if (nSpell == 389)
        {
            nPoly = 110;
        }
        else if (nSpell == 390)
        {
            nPoly = 111;
        }
        else if (nSpell == 391)
        {
            nPoly = 112;
        }
    }
    else
    {
        //Determine Polymorph subradial type
        if(nSpell == 387)
        {
            nPoly = POLYMORPH_TYPE_GIANT_SPIDER;
        }
        else if (nSpell == 388)
        {
            nPoly = POLYMORPH_TYPE_TROLL;
        }
        else if (nSpell == 389)
        {
            nPoly = POLYMORPH_TYPE_UMBER_HULK;
        }
        else if (nSpell == 390)
        {
            nPoly = POLYMORPH_TYPE_PIXIE;
        }
        else if (nSpell == 391)
        {
            nPoly = POLYMORPH_TYPE_ZOMBIE;
        }
    }
    ePoly = EffectPolymorph(nPoly);
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_POLYMORPH_SELF, FALSE));

    //Apply the VFX impact and effects
    AssignCommand(oTarget, ClearAllActions()); // prevents an exploit
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePoly, oTarget, TurnsToSeconds(nDuration));
}

