//::///////////////////////////////////////////////
//:: Bigby's Forceful Hand
//:: [x0_s0_bigby2]
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    dazed vs strength check (+14 on strength check); Target knocked down.
    Target dazed down for (1+ caster lvl / 4) rounds if fails refex throw.

*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: September 7, 2002
//:://////////////////////////////////////////////
//:: Last Updated By: Andrew Nobbs May 01, 2003

#include "x0_i0_spells"
#include "x2_inc_spellhook"
#include "ku_boss_inc"

void main()
{

/*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables
    object oTarget = GetSpellTargetObject();
    float fDurationSec;
    fDurationSec = RoundsToSeconds(3);
    int nMetaMagic = GetMetaMagicFeat();
    //Check for metamagic extend
    if (nMetaMagic == METAMAGIC_EXTEND) //Duration is +100%
    {
         fDurationSec = fDurationSec * 2;
    }
    ReduceSpellDurationForBoss(oTarget, fDurationSec, GetCasterLevel(OBJECT_SELF));
    if(!GetIsReactionTypeFriendly(oTarget))
    {
        // Apply the impact effect
        effect eImpact = EffectVisualEffect(VFX_IMP_BIGBYS_FORCEFUL_HAND);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oTarget);
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 460, TRUE));
        if(!MyResistSpell(OBJECT_SELF, oTarget))
        {

            // * bullrush succesful, knockdown target for duration of spell
            if (!MySavingThrow(SAVING_THROW_REFLEX,oTarget,GetSpellSaveDC()+GetThalieSpellDCBonus(OBJECT_SELF),SAVING_THROW_TYPE_SPELL) )
            {
                effect eVis = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);
                effect eKnockdown = EffectDazed();
                effect eKnockdown2 = EffectKnockdown();
                effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
                //Link effects
                effect eLink = EffectLinkEffects(eKnockdown, eDur);
                eLink = EffectLinkEffects(eLink, eKnockdown2);
                //Apply the penalty
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDurationSec);
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, fDurationSec);
                // * Bull Rush succesful
                FloatingTextStrRefOnCreature(8966,OBJECT_SELF, FALSE);
            }
            else
            {
                FloatingTextStrRefOnCreature(8967,OBJECT_SELF, FALSE);
            }
        }
    }
}


