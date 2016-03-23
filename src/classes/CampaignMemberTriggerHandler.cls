//This is the handler class for trigger AssignVolunteerTrigger on Campaign Members.
public class CampaignMemberTriggerHandler{
    
    //This method Accepts the Trigger.New list i.e. the new values of campaign members that are to be inserted.
    public void AssignVolunteer(List<CampaignMember> NewRecord){
        List<AggregateResult> CampaignMemberList=[SELECT COUNT(Name) volunteerCount
                                                       , Campaign_Awareness_Type__c
                                                       , City 
                                                    FROM CampaignMember
                                                   WHERE Participation_Role__c='Volunteer'
                                                     AND Campaign.Name='TRY Health Campaign'
                                                GROUP BY Campaign_Awareness_Type__c,City ];  
        List<Campaign> objCampaign=[SELECT Id
                                FROM Campaign
                               WHERE Name='TRY Health Campaign'];
        Map<String,Map<String,Integer>> volunteerCategorisationMap=new Map<String,Map<String,Integer>>();
        Map<String,Integer> cityDistributionMap=new Map<String,Integer>();
        
        for(AggregateResult objAggregate: CampaignMemberList)            //Creating map of Campaign Awareness Type and City with the volunteer count
        {
            if(volunteerCategorisationMap.containsKey((String)objAggregate.get('Campaign_Awareness_Type__c') )){
                cityDistributionMap=volunteerCategorisationMap.get((String)objAggregate.get('Campaign_Awareness_Type__c'));
                cityDistributionMap.put((String)objAggregate.get('City'),(Integer)objAggregate.get('volunteerCount'));
                volunteerCategorisationMap.put((String)objAggregate.get('Campaign_Awareness_Type__c'),cityDistributionMap);
            }
            else{
                volunteerCategorisationMap.put((String)objAggregate.get('Campaign_Awareness_Type__c'),new Map<String,Integer>{(String)objAggregate.get('City')=>(Integer)objAggregate.get('volunteerCount')});
            }
        }
        
        system.debug(volunteerCategorisationMap);
        for(CampaignMember objCampaignMember: NewRecord)  //Iterating through new record
        {
            system.debug(objCampaignMember);
            if(objCampaignMember.CampaignId.equals(objCampaign[0].Id) && objCampaignMember.Participation_Role__c.equals('Volunteer')){        
        
            if( objCampaignMember.City!=Null  ){
                
                if(volunteerCategorisationMap.containsKey(objCampaignMember.Campaign_Awareness_Type__c)){
                    Map<String,Integer> innerMap=volunteerCategorisationMap.get(objCampaignMember.Campaign_Awareness_Type__c);
                    
                    if(innerMap.containsKey(objCampaignMember.City)){
                        Integer tempCount=innerMap.get(objCampaignMember.City);
                        
                        if(tempCount<20){
                            tempCount++;
                            innerMap.put(objCampaignMember.City,tempCount);
                            volunteerCategorisationMap.put(objCampaignMember.Campaign_Awareness_Type__c,innerMap);
                        }
                        else{
                            system.debug('.........Team Limit Reached..........');
                            objCampaignMember.addError('Team Limit has reached. You can register as Participant.'); 
                        }
                        
                    }
                    else{
                        innerMap.put(objCampaignMember.City,1);
                        volunteerCategorisationMap.put(objCampaignMember.Campaign_Awareness_Type__c,innerMap);
                    }
                    
                }
                else{
                    volunteerCategorisationMap.put(objCampaignMember.Campaign_Awareness_Type__c,new Map<String,Integer>{objCampaignMember.City=>1});
                }    
                
            }
            else{
                objCampaignMember.addError('City is Null');
            }
        }    
            
        }
        system.debug(volunteerCategorisationMap);
    }
   
}