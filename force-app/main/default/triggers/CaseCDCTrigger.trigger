trigger CaseCDCTrigger on CaseChangeEvent (after insert) {
    
    List<CaseSyncQueueable.EventData> events =
        new List<CaseSyncQueueable.EventData>();
    
    for (CaseChangeEvent evt : Trigger.New) {
        System.debug('=== CDC FIRED ===');
        EventBus.ChangeEventHeader header =
            evt.ChangeEventHeader;
        
        CaseSyncQueueable.EventData data =
            new CaseSyncQueueable.EventData();
        
        data.changeType = header.getChangeType();
        
        if(header.getRecordIds() != null &&
           !header.getRecordIds().isEmpty()) {
               
               data.recordId =
                   header.getRecordIds()[0];
           }
        
        events.add(data);
        
        System.debug('ChangeType: ' + header.getChangeType());
        System.debug('RecordIds: ' + header.getRecordIds());
    }
    
    System.enqueueJob(
        new CaseSyncQueueable(events)
    );
    
    
}