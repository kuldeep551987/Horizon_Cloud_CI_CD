public class UpdateContact {
    public static void updatecon()
    {
        List<contact> con = [select id,firstname from contact];
        ContactUpdateQueueableClass qu = new ContactUpdateQueueableClass('Contact',con);
        system.enqueuejob(qu);
    }
}