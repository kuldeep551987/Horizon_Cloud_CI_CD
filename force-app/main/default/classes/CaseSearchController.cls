public without sharing class CaseSearchController
{
@AuraEnabled
public static List<Case> casesearchmethod(String caseNumbers)
{
if(string.isBlank(caseNumbers))
{
    return new List<case>();
}
else
{
List<string> casenumberlist = caseNumbers.split(',');

List<case> cases = new List<case>();

if(schema.sObjecttype.case.isaccessible())
{
cases = [select Id,CaseNumber,Subject,Origin,Status,Priority from case where casenumber in :casenumberlist];
}
return cases;
}
}
}