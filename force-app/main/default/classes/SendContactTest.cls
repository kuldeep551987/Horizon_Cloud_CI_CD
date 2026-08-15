@isTest
public class SendContactTest 
{
    @isTest
    public static void test()
    {
        Test.setmock(httpcalloutmock.class,new Httpmockresponse());
        contact con = new contact(firstname='Test',Lastname='Test');
        insert con;
        test.starttest();
        SendContact.senddata();
        test.stoptest();
    }
}