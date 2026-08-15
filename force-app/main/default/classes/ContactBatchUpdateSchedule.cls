public class ContactBatchUpdateSchedule implements schedulable
{
    public void execute(schedulablecontext sc)
    {
        ContactBatchUpdate bc = new ContactBatchUpdate();
        Database.ExecuteBatch(bc);
    }
}