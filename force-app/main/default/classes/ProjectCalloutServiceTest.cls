@isTest
private class ProjectCalloutServiceTest {

    @isTest
    static void testPostOpportunityToPMS() {
        // Create test data
        Account acc = new Account();
        Opportunity opp = new Opportunity(
            Name = 'Test Opportunity',
            AccountId = acc.Id,
            CloseDate = Date.parse('07/05/2024'),
            Amount = 3,
            StageName = 'Closed Won'
        );
        insert opp;

        Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMock());

        Test.startTest();
        	ProjectCalloutService.postOpportunityToPMS(new List<Id>{opp.Id});
        Test.stopTest();
        
        HttpRequest actualRequest = ProjectCalloutServiceMock.getLastRequest();
        System.assertEquals('callout:ProjectService', actualRequest.getEndpoint());
        System.assertEquals('POST', actualRequest.getMethod());
        System.assertEquals('Bearer ' + ServiceTokens__c.Token__c, actualRequest.getHeader('Authorization'));
        System.assertEquals('application/json;charset=UTF-8', actualRequest.getHeader('Content-Type'));
        
        // Perform assertions based on the actual HTTP request and response
        HttpResponse actualResponse = ProjectCalloutServiceMock.getLastResponse();
        System.assertEquals(201, actualResponse.getStatusCode());
        System.assertEquals('{"status": "Success", "message": "Mock response"}', actualResponse.getBody());
    }
    
    @isTest
    static void testQueueablePMSCall() {
        Test.startTest();
        ProjectCalloutService.QueueablePMSCall queueable = new ProjectCalloutService.QueueablePMSCall();
        System.enqueueJob(queueable);
        Test.stopTest();

        List<AsyncApexJob> jobs = [SELECT Id, Status FROM AsyncApexJob WHERE JobType = 'Queueable'];
        System.assertNotEquals(0, jobs.size(), 'Queueable job should be enqueued');
        System.assertEquals('Queued', jobs[0].Status, 'Job should be in Queued status');
    }

}