trigger CampaignMemberTrigger on CampaignMember (before insert) {

    if(Trigger.isBefore && Trigger.isInsert){
        CampaignMemberTriggerHandler objVolunteer=new CampaignMemberTriggerHandler();
        system.debug(Trigger.New);
        objVolunteer.AssignVolunteer(Trigger.New);  
        
    } 
}