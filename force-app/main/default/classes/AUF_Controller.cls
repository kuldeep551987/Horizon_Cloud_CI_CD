public class AUF_Controller 
{
    public case cs{get;set;}
    public Id taskId{get;set;}
    public string comments{get;set;}
    public boolean showForm{get;set;}
    
    public AUF_Controller()
    {
        showForm = true;
        Id caseId = ApexPages.currentPage().getParameters().get('id');
        taskId = ApexPages.currentPage().getParameters().get('taskId');
        if (caseId != null) {
            cs = [SELECT Id, CaseNumber, Resolution__c,Substatus__c,AccountId, Follow_Up_Rule_Configuration__r.From_Email_Address__c,
                    Follow_Up_Rule_Configuration__r.AU_FU_Comments_Recipient__c,Follow_Up_Rule_Configuration__r.AR_Not_Resolved_Email_Template__c 
                    FROM Case WHERE Id = :caseId LIMIT 1];
        } else {
            cs = new Case();
        }
    }
    
    public void submitresponse()
    {
        if (String.isNotBlank(comments)) { 
            try{
                Activities__c act = new Activities__c();
                act.Case__c = cs.Id;
                act.Description__c = comments;
                act.Activity_Source__c = 'Follow-up on Case';
                act.Status__c = 'Done';
                act.Type__c = 'Issue not resolved';
                act.Priority__c = '4-Low';
                act.Account__c = cs.AccountId;
                insert act;

                cs.Substatus__c = 'Response Received';
                update cs;
                showForm = false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Response submitted successfully.'));
                
                sendEmailUsingTemplate(act.Id, cs);
            }catch(Exception e){
                system.debug(e.getMessage());
            }
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter comments before submitting.'));
        }
    }
    
    public static void sendEmailUsingTemplate(Id actId,Case c) {
        try {
            Contact tempContact = new Contact(
                LastName = 'TempRecipient',
                Email    = c.Follow_Up_Rule_Configuration__r.AU_FU_Comments_Recipient__c
            );
            insert tempContact;

            EmailTemplate emailtemp = [SELECT Id FROM EmailTemplate WHERE DeveloperName =:c.Follow_Up_Rule_Configuration__r.AR_Not_Resolved_Email_Template__c LIMIT 1];
            Id orgWideEmailId = [SELECT Id FROM OrgWideEmailAddress WHERE Address =: c.Follow_Up_Rule_Configuration__r.From_Email_Address__c LIMIT 1].Id;
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setTargetObjectId(tempContact.Id);
            email.setTemplateId(emailtemp.Id);
            email.setWhatId(actId);
            email.setOrgWideEmailAddressId(orgWideEmailId);

            // Ensure that the email is sent to the target object's email address
            email.setSaveAsActivity(false); // Optional: Don't log as an activity

            // Send the email
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
            
            delete tempContact;
            System.debug('Email sent successfully.');
        } catch (Exception ex) {
            System.debug('Error sending email: ' + ex.getMessage());
        }
    }
}