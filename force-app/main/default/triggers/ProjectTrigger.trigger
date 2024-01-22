trigger ProjectTrigger on Project__c (after update) {
    for(Project__c project: Trigger.new){
        BillingCalloutService.callBillingService(project.Status__c,project.ProjectRef__c, project.Billable_Amount__c);    
    }
}