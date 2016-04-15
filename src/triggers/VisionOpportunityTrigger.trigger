//This trigger is on the custom object Vision Opportunity.
trigger VisionOpportunityTrigger on Vision_Opportunity__c (before insert,
														   before update) {

    //This Trigger initates before the insertion of a vision opportunity record.
    if(Trigger.isInsert && Trigger.isBefore){
   		VisionOpportunityTriggerHandler.beforeVisionOpportunityInsert(Trigger.New);
    }
    
    //This trigger initiates before the updation of a vision opportunity record.
    if(Trigger.isUpdate && Trigger.isBefore){
    	VisionOpportunityTriggerHandler.beforeVisionOpportunityInsert(Trigger.New);
    }
}