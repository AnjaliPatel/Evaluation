//This trigger is for checking the vision opportunity and related manipulations.
trigger OpportunityTrigger on Opportunity (before insert) {
    
    //This method initiates the trigger for the before insert on the opportunity.
    if(Trigger.isBefore && Trigger.isInsert){
        if(CheckTriggerRecursion.checkTriggerExecutionFlag()){
            OpportunityTriggerHandler.createVisionOpportunity(Trigger.new);
        }
    }
}