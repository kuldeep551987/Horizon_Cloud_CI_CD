public class SendContact 
{
    @invocablemethod
    public static void senddata()
    {
        List<contact> conlist = [select id,firstname,lastname from contact order by createddate limit 1];
        
        if(!conlist.isEmpty())
        {
            //for(Contact con:conlist)
            //{
                Map<string,object> conmap = new Map<string,object>{
                    'contactfirstname'=>conlist[0].firstname,
                        'contactlastname'=>conlist[0].lastname
                        };
                            string JSONbody = JSON.serialize(conmap);
                
                http http = new http();
                httprequest req = new httprequest();
                req.setEndpoint('callout:Agentforce1/services/apexrest/CreateContact/');
                req.setMethod('POST');
                req.setHeader('content-Type','application/json');
                req.setBody(JSONbody);
                httpresponse res = http.send(req);
            //}
        }
    }
}