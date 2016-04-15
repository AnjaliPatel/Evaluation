//This Class acts as the helper class for the vision opportunity trigger handler.
public class VisionOpportunityTriggerHelper {
    
    //This method copies the record of vision opportunity to opportunity.
    public static Opportunity copyVisionToOpportunity(Vision_Opportunity__c objVisionOpportunity,Opportunity objOpportunity){
    	objOpportunity.Name=objVisionOpportunity.Vision_Opportunity_Name__c;
    	objOpportunity.CloseDate=objVisionOpportunity.Close_Date__c;
    	objOpportunity.Amount=objVisionOpportunity.Amount__c;
    	objOpportunity.StageName=objVisionOpportunity.Stage_Name__c;
    	objOpportunity.LeadSource=objVisionOpportunity.LeadSource__c;
    	objOpportunity.Invoice_Number__c=objVisionOpportunity.Invoice_Number__c;
    	return objOpportunity;
    }
    
    //This method returns a list of opportunities whose stage is not closed won.
    public static List<Opportunity> extractExistingOpportunites(){
    	return [SELECT Id
					 , Name
					 , Invoice_Number__c
					 , StageName
					 , CloseDate
				  FROM Opportunity
				 WHERE Invoice_Number__c!=Null
				   AND StageName!='Closed Won'];
    }
}