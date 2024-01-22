@RestResource(urlMapping='/project/*')
global class ProjectRESTService {
    @HttpPost
    global static String postProjectData(String ProjectRef, String ProjectName, String OpportunityId, Date StartDate, Date EndDate, Double Amount, String Status){
       Savepoint save = Database.setSavepoint();
        try{
            Project__c project = new Project__c();
            project.ProjectRef__c = ProjectRef;
            project.Name = ProjectName;
            project.Opportunity__c = OpportunityId;
            project.Start_Date__c = StartDate;
            project.End_Date__c = EndDate;
            project.Billable_Amount__c = Amount;
            project.Status__c = Status;            
            upsert project;
            
            Opportunity opp = new Opportunity();
            opp.Id = opportunityId;
            opp.DeliveryInstallationStatus__c = 'In progress';
            update opp;
            
            return 'OK';
            
        }catch(Exception ex){
            Database.rollback(save);
            return ex.getMessage();
        }      

    }
}