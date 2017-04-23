//::///////////////////////////////////////////////
//:: Ethereal Visage
//:: NW_S0_EtherVis.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Caster gains 20/+3 Damage reduction and is immune
    to 2 level spells and lower.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////

#include "x2_inc_spellhook"
#include "sh_effects_const"

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


    object oTarget = GetSpellTargetObject();
    effect eVis = EffectVisualEffect(VFX_DUR_ETHEREAL_VISAGE);
    effect eDam = EffectDamageReduction(20, DAMAGE_POWER_PLUS_THREE);
    effect eSpell = EffectSpellLevelAbsorption(2);
    effect eConceal = EffectConcealment(25);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect im1 = EffectDamageImmunityIncrease(DAMAGE_TYPE_BLUDGEONING,25);
    effect im2 = EffectDamageImmunityIncrease(DAMAGE_TYPE_PIERCING,25);
    effect im3 = EffectDamageImmunityIncrease(DAMAGE_TYPE_SLASHING,25);
    int iEffect;
    effect eLoop = GetFirstEffect(oTarget);
    while (GetIsEffectValid(eLoop))
    {
      iEffect = GetEffectSpellId(eLoop);
      if (iEffect== EFFECT_ETHERNAL_VISAGE)
      {
        RemoveEffect(oTarget,eLoop);
      }
      eLoop = GetNextEffect(oTarget);
    }


    effect eLink = EffectLinkEffects(eDam, eVis);
    eLink = EffectLinkEffects(eLink, eSpell);
    eLink = EffectLinkEffects(eLink, eDur);
    eLink = EffectLinkEffects(eLink, eConceal);
    eLink = EffectLinkEffects(eLink, im1);
    eLink = EffectLinkEffects(eLink, im2);
    eLink = EffectLinkEffects(eLink, im3);
    SetEffectSpellId(eLink,EFFECT_ETHERNAL_VISAGE);
    int nMetaMagic = GetMetaMagicFeat();
    int nDuration = GetCasterLevel(OBJECT_SELF);
    nDuration = GetThalieCaster(OBJECT_SELF,oTarget,nDuration,FALSE);
    //Enter Metamagic conditions
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_ETHEREAL_VISAGE, FALSE));

    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2; //Duration is +100%
    }

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
}

