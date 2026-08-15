public class ContactBatchUpdate implements Database.Batchable<sObject>,Database.Stateful
{
    public integer recordprocessed=0;
    
    public Database.QueryLocator start(Database.Batchablecontext bc)
    {
        return Database.getQueryLocator('select id,firstname,lastname from contact');
    }
    
    public void execute(Database.BatchableContext bc,List<contact> conlist)
    {
        List<contact> updateconlist = new List<contact>();
        
        for(Contact con:conlist)
        {
            con.firstname = con.firstname+'_2';
            updateconlist.add(con);
            recordprocessed++;
        }
        if(!updateconlist.isEmpty())
            update updateconlist;
    }
    
    public void finish(Database.batchablecontext bc)
    {
        system.debug('Total Record Processesd '+recordprocessed+' for job with job id '+bc.getJobid());
    }
}