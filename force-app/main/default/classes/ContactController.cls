public with sharing class ContactController 
{
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts(string searchKey) 
    {
        List<Contact> contacts = new List<Contact>();
        if (searchKey != null && searchKey != '') 
        {
            contacts =  [SELECT Id, FirstName, LastName, Email FROM Contact WHERE FirstName LIKE :('%' + searchKey + '%') OR LastName LIKE :('%' + searchKey + '%') LIMIT 100];
        }
        return contacts;
    }
}