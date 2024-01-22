@isTest
private class ProjectRESTServiceTest {
    @isTest
    static void testPostProjectDataSuccess() {
        Opportunity opp = new Opportunity(
            Name = 'Test Opportunity',
            DeliveryInstallationStatus__c = 'In progress',
            StageName = 'Closed Won',
            CloseDate = Date.today().addDays(1)
        );
        insert opp;
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/project';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"ProjectRef": "Ref123", "ProjectName": "TestProject", "OpportunityId": "' + opp.Id + '", "StartDate": "' + Date.today() + '", "EndDate": "' + Date.today().addDays(1) + '", "Amount": 1000, "Status": "Running"}');


        Test.startTest();
        RestContext.request = req;
        	String response = ProjectRESTService.postProjectData('Ref123', 'TestProject', opp.Id, Date.today(), Date.today().addDays(1), 1000, 'Running');
        Test.stopTest();


        Project__c project = [SELECT Id FROM Project__c WHERE ProjectRef__c = 'Ref123'];
        System.assertNotEquals(null, project, 'Project should be created');
        
        System.assertEquals('OK', response);

        Opportunity updatedOpp = [SELECT Id, DeliveryInstallationStatus__c FROM Opportunity WHERE Id = :opp.Id];
        System.assertEquals('In progress', updatedOpp.DeliveryInstallationStatus__c, 'Opportunity status should be updated');
    }
     @isTest
    static void testProjectDataFailure(){
        
        RestRequest request = new RestRequest();
        request.httpMethod = 'POST';
        request.requestURI = '/services/apexrest/project';
        
        RestContext.request = request;
        
        Test.startTest();
        String response = ProjectRESTService.postProjectData(
                            'Test Ref 123', 
                            'Test Project', 
                            'test invalid id', 
                            Date.today(), 
                            Date.today().addDays(1), 
                            110000, 
                            'Running');
        Test.stopTest();
        
        System.assertEquals('Invalid id: test invalid id', response);
    }
}