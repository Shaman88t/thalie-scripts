//::///////////////////////////////////////////////
//:: Terrifying Rage Script
//:: x2_s2_terrage_a.nss
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*

    Upon entering the aura of the creature the player
    must make a will save or be struck with fear because
    of the creatures presence.

    - Save DC is a Intimidate check result of the raging character

    - If the creature has less HitDice than the barbarian they freeze in terror 1d3 rounds

    - if the creature has less HD than the BarbarianHD*2, they are shaken (-2 to attack, -2 to saves)

    - if the creature has more than double HD than the Barb, they are immune to the effect

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-07-10
//:://////////////////////////////////////////////
#include "NW_I0_SPELLS"
#include "x2_i0_spells"
#include "ku_boss_inc"

void main()
{
    //Declare major variables
    object oTarget = GetEnteringObject();
    effect eVis = EffectVisualEffect(VFX_IMP_FEAR_S);
    effect eDur = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR);
    effect eDur2 = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eLink;

    object oBarb =GetAreaOfEffectCreator();
    int nHD = GetHitDice(GetAreaOfEffectCreator());
    int iCon = GetAbilityModifier(ABILITY_CONSTITUTION);
    int nLevel = GetLevelByClass(CLASS_TYPE_BARBARIAN);
    int nDC = 10 + GetSkillRank(SKILL_INTIMIDATE,oBarb,TRUE)/3 +nLevel/2 + iCon;
    int nDuration = d3();
    if(GetIsEnemy(oTarget, oBarb))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(oBarb, GetSpellId()));
        //Make a saving throw check
          if(!MySavingThrow(SAVING_THROW_WILL, oTarget, 0, SAVING_THROW_TYPE_FEAR))
          {
                return;
          }
          if(!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_FEAR))
            {

                // Hit dice below barb.... run like hell!
                if (GetHitDice(oTarget)< GetHitDice(oBarb) && !GetIsBoss(oTarget))
                {
                    //Apply the VFX impact and effects
//                    effect eFear = EffectParalyze();
                    effect eStun = EffectStunned();
                    eLink = EffectLinkEffects(eStun, eDur);
                    eLink = EffectLinkEffects(eLink, eDur2);
                    eLink = ExtraordinaryEffect(eLink);
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                    PlayVoiceChat(VOICE_CHAT_HELP,oTarget);
                }
                // Up to twice the barbs HD ... shaken
                else if (GetHitDice(oTarget)< GetHitDice(oBarb)*2)
                {
                    effect eShake1 = EffectSavingThrowDecrease(SAVING_THROW_ALL,2);
                    effect eShake2 = EffectAttackDecrease(2);
                    eLink = EffectLinkEffects(eShake1, eDur);
                    eLink = EffectLinkEffects(eLink, eShake2);
                    eLink = EffectLinkEffects(eLink, eDur2);
                    eLink = ExtraordinaryEffect(eLink);
                    FloatingTextStrRefOnCreature(83583,oTarget);
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                 }
                 // else immune
          }
      }

}
