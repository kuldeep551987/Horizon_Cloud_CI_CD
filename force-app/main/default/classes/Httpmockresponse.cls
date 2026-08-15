public class Httpmockresponse implements httpcalloutmock
{
    public httpresponse respond(httprequest req)
    {
        httpresponse  resp = new Httpresponse();
        resp.setheader('content-type','application/json');
        resp.setbody('SUCCESS');
        resp.setstatuscode(200);
        return resp;
    }
}