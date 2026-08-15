public class ContactUpdateQueueableClass implements queueable
{
    string objName;
    List<contact> contacts;
    
    public ContactUpdateQueueableClass(string objectname,List<Contact> conlist)
    {
        this.objName = objectname;
        this.contacts = conlist;
    }
    
    public void execute(QueueableContext qc)
    {
        if(objName=='Contact')
        {
            List<contact> contactstoUpdate = new List<contact>();
            for(contact con:contacts)
            {
                con.firstname = con.firstname+'_4';
                contactstoUpdate.add(con);
            }
            if(!contactstoUpdate.isEmpty())
                update contactstoUpdate;
        }
    }
}