public class CaseHelperController {
    @AuraEnabled(cacheable=true)
    public static Map<String, List<Id>> getContactSiteStudyMap(Id contactId) {
        Map<String, List<Id>> result = new Map<String, List<Id>>();

        List<Id> siteIds = new List<Id>();
        List<Id> studyIds = new List<Id>();

        for (Contact_Sites__c cs : [
            SELECT Site__c FROM Contact_Sites__c WHERE Contact__c = :contactId AND Site__c != NULL
        ]) {
            siteIds.add(cs.Site__c);
        }

        for (Contact_Studies__c cs : [
            SELECT Study__c FROM Contact_Studies__c WHERE Contact__c = :contactId AND Study__c != NULL
        ]) {
            studyIds.add(cs.Study__c);
        }

        result.put('siteIds', siteIds);
        result.put('studyIds', studyIds);

        return result;
    }

    @AuraEnabled(cacheable=true)
    public static Map<Id, String> getSiteNames(List<Id> siteIds) {
        Map<Id, String> siteMap = new Map<Id, String>();
        for (Site__c s : [SELECT Id, Name FROM Site__c WHERE Id IN :siteIds]) {
            siteMap.put(s.Id, s.Name);
        }
        return siteMap;
    }

    @AuraEnabled(cacheable=true)
    public static Map<Id, String> getStudyNames(List<Id> studyIds) {
        Map<Id, String> studyMap = new Map<Id, String>();
        for (Study__c s : [SELECT Id, Name FROM Study__c WHERE Id IN :studyIds]) {
            studyMap.put(s.Id, s.Name);
        }
        return studyMap;
    }
}