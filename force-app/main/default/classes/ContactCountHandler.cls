public class ContactCountHandler 
{
    public static void countcontactforAccount(List<contact> conlist,Map<id,contact> conmap,boolean isinsert,boolean isupdate,boolean isdelete,boolean isundelete)
    {
        Set<Id> accIds = new Set<Id>();
        
        if(isinsert || isundelete)
        {
            for(contact con:conlist)
                accIds.add(con.AccountId);
        }
        
        if(isdelete)
        {
            for(contact con:conmap.values())
            {
                accIds.add(con.AccountId);
            }
        }
        
        
        if(isupdate)
        {
            for(contact con:conlist)
            {
                contact oldmap = conmap.get(con.id);
                accIds.add(con.AccountId);
                if(con.AccountId!=oldmap.AccountId)
                    accIds.add(oldmap.AccountId);
            }
        }
        
        if(accIds.isEmpty())
            return;
        
        List<Account> acctoupdate = new List<Account>();
        
        for(AggregateResult ar:[select AccountId accid,Count(id) cnt from contact where accountid in:accIds group by AccountId])
        {
            acctoupdate.add(new Account(id=(id)ar.get('accid'),NumberofLocations__c=(integer)ar.get('cnt')));
        }
        if(!acctoupdate.isEmpty())
            update acctoupdate;
    }
}