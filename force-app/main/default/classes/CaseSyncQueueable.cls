public class CaseSyncQueueable
implements Queueable, Database.AllowsCallouts {

    public class EventData {

        public String changeType;
        public String recordId;
    }

    private List<EventData> events;

    public CaseSyncQueueable(
        List<EventData> events
    ) {
        this.events = events;
    }

    public void execute(
        QueueableContext context
    ) {

        Set<Id> caseIds = new Set<Id>();

        for(EventData evt : events) {

            if(evt.recordId != null &&
               evt.changeType != 'DELETE') {

                caseIds.add(
                    (Id)evt.recordId
                );
            }
        }

        Map<Id, Case> caseMap =
            new Map<Id, Case>();

        if(!caseIds.isEmpty()) {

            caseMap =
                new Map<Id, Case>(
                    [
                        SELECT Id,
                               CaseNumber,
                               Subject,
                               Description,
                               Status,
                               Priority//,
                               //Source_Org__c
                        FROM Case
                        WHERE Id IN :caseIds
                        ALL ROWS
                    ]
                );
        }

        List<CaseSyncPayload> payloads =
            new List<CaseSyncPayload>();

        for(EventData evt : events) {

            CaseSyncPayload payload =
                new CaseSyncPayload();

            payload.changeType =
                evt.changeType;

            payload.sourceOrg =
                'ORG_A';

            payload.sourceCaseId =
                evt.recordId;

            if(caseMap.containsKey(
                (Id)evt.recordId
            )) {

                Case c =
                    caseMap.get(
                        (Id)evt.recordId
                    );

               // if(c.Source_Org__c ==
                  // 'ORG_B') {

                 //   continue;
               // }

                payload.caseNumber =
                    c.CaseNumber;

                payload.subject =
                    c.Subject;

                payload.description =
                    c.Description;

                payload.status =
                    c.Status;

                payload.priority =
                    c.Priority;
            }

            payloads.add(payload);
        }

        sendPayload(payloads);
    }

    private static void sendPayload(
        List<CaseSyncPayload> payloads
    ) {

        HttpRequest req =
            new HttpRequest();

        req.setEndpoint(
            'callout:Agentforce1/services/apexrest/casesync'
        );

        req.setMethod('POST');

        req.setHeader(
            'Content-Type',
            'application/json'
        );

        req.setTimeout(
            120000
        );

        req.setBody(
            JSON.serialize(payloads)
        );

        Http http =
            new Http();

        HttpResponse response =
            http.send(req);

        System.debug(
            response.getStatusCode()
        );

        System.debug(
            response.getBody()
        );
    }
}