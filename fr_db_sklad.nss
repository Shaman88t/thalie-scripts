#include "aps_include"


void __setDescriptionWithItems()
{
  // Nejak zjistit PC object
  object oPC = GetLastClosedBy();
  // Definovani nazvu persistentni promenne
  string sVarName = "craft_truhla_pocet_"+GetTag(OBJECT_SELF);
  string sSqlVar = SQLEncodeSpecialChars(sVarName);

  string sSQL = "SELECT player, tag, val FROM pwdata WHERE name = '"+sSqlVar+"'";
  SQLExecDirect(sSQL);

  string sDescr = "";
  while(SQLFetch() == SQL_SUCCESS)
  {
    string sPlayer = SQLDecodeSpecialChars(SQLGetData(1));
    string sTag = SQLDecodeSpecialChars(SQLGetData(2));
    string sVal = SQLDecodeSpecialChars(SQLGetData(3));

    sDescr = sDescr +"\n" + sTag + sVal + "kusu dreva.";
  }

  SetDescription(OBJECT_SELF, sDescr, TRUE);
}

void main()
{
  // Nejak zjistit PC object
  object oPC = GetLastClosedBy();
  // Definovani nazvu persistentni promenne
  string sVarName = "craft_truhla_pocet_"+GetTag(OBJECT_SELF);

  // Nacteni persistentni promenne z db
  int nWood = GetPersistentInt(oPC,sVarName,"pwdata");
  object oCont = (OBJECT_SELF);
  object oItem = GetFirstItemInInventory(oCont);
  while(GetIsObjectValid(oItem))
  {
    string sTag = GetTag(oItem);
    if(sTag == "tc_Drev_Vrb" ||
    sTag == "cnrBranchOak" ||
    sTag =="tc_Drev_Zel"||
    sTag =="tc_Drev_Jil")
    {
      /* pricti pocet itemu */
      nWood++;
    }

    oItem = GetNextItemInInventory(oCont);
  }

  // Ulozit aktualizovany pocet nWood do persistentni db
  SetPersistentInt(oPC, sVarName, nWood);


  // Blok ko� = funkcionalita ko�e - smaze vsechny itemy
  oItem = GetFirstItemInInventory(oCont);
  while(GetIsObjectValid(oItem))
  {
    DestroyObject(oItem);
    oItem = GetNextItemInInventory(oCont);
  }

  __setDescriptionWithItems();
}
