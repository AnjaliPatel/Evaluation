//This is the handler class for the Opportunity trigger.
public class OpportunityAfterInsertTriggerHandler {
    //This is the method takes the newly created opportunity,searches for the vision opportunity and performs the required action.
    public static void createVisionOpportunity(Map<Id,Opportunity> opportunityRecordsMap){
    	Map<Id,Opportunity> existingOpportunityMap=new Map<Id,Opportunity>([SELECT Id
    													 						 , Name
    													 						 , Customer__c
    													 						 , Invoice_Number__c
    													 						 , StageName
    													 						 , CloseDate
    												  						  FROM Opportunity
    												 						 WHERE Invoice_Number__c!=Null
    												 						   AND Id NOT IN:opportunityRecordsMap.keyset()]);
    	Map<Id,OpportunityLineItem> opportunityLineItemMap=new Map<Id,OpportunityLineItem>();
    	List<OpportunityLineItem> opportunityLineItemList=[SELECT Id
    															, Name
    															, OpportunityId
    															, Quantity
    														 FROM OpportunityLineItem];
    	for(OpportunityLineItem objLineItem: opportunityLineItemList){
    		opportunityLineItemMap.put(objLineItem.OpportunityId,objLineItem);
    	}
    	List<Opportunity> cloneRecords=new List<Opportunity>();
    	List<Opportunity> visionOpportunityRecords=new List<Opportunity>();
    	List<Opportunity> insertedOpportunities=new List<Opportunity>();
    	system.debug(existingOpportunityMap);
    	Map<Decimal,Id> opportunityIdInvoiceNumberMap=new Map<Decimal,Id>();
    	for(Id objMap: existingOpportunityMap.keyset()){
    		opportunityIdInvoiceNumberMap.put(existingOpportunityMap.get(objMap).Invoice_Number__c,objMap);
    	}
    	system.debug(opportunityIdInvoiceNumberMap);
    	for(Id currentOpportunityId: opportunityRecordsMap.keyset()){
    		Opportunity objNewOpportunity=opportunityRecordsMap.get(currentOpportunityId);
    		if(opportunityIdInvoiceNumberMap.containsKey(objNewOpportunity.Invoice_Number__c)){
				Opportunity requiredOpportunity=existingOpportunityMap.get(opportunityIdInvoiceNumberMap.get(objNewOpportunity.Invoice_Number__c));
				Opportunity objClone=requiredOpportunity.clone(false,false,true,true);
				cloneRecords.add(objClone);
				//objNewOpportunity.StageName='Closed Won';
				//objNewOpportunity.Vision_Lookup__c=requiredOpportunity.Id;
				requiredOpportunity.Vision_Opportunity__c=true;
				system.debug(requiredOpportunity.Vision_Opportunity__c);
				visionOpportunityRecords.add(requiredOpportunity);
				insertedOpportunities.add(objNewOpportunity);
			}
			else{
				
			}
    	}
    	insert cloneRecords;
		update visionOpportunityRecords;
		update insertedOpportunities;
    }
}