//This is the handler class for the Vision Opportunity Trigger.
public class VisionOpportunityTriggerHandler {
    
    //This method accepts the new vision opportunity record and checks for opportunity with same invoice number 
    //and hence performs the required actions.
    public static void beforeVisionOpportunityInsert(List<Vision_Opportunity__c> visionOpportunityRecords){
    	
    	List<Opportunity> cloneRecords=new List<Opportunity>();
    	List<Opportunity> updatedOpportunityList=new List<Opportunity>();
    	Map<Decimal,Id> opportunityInvoiceNumberIdMap=new Map<Decimal,Id>();
    	Map<Id,List<OpportunityLineItem>> opportunityIDLineItemMap=new Map<Id,List<OpportunityLineItem>>();
    	List<Id> clonedOpportunityIdList=new List<Id>();
    	List<OpportunityLineItem> updatedLineItemList=new List<OpportunityLineItem>();
    	List<OpportunityLineItem> toBeDeletedLineItemsList=new List<OpportunityLineItem>();
    	List<Opportunity> newOpportunities=new List<Opportunity>();
    	
    	//Deactivating the validation rule for the stagename of opportunity.
    	ValidationActivationSetting__c objCustomSetting= ValidationActivationSetting__c.getInstance(Userinfo.getUserId()); 
    	objCustomSetting.Activate_Validation_Rule__c=false;
    	update objCustomSetting;
    	
    	//Creating a map with key as opportunity Id and opportunity record as the value.
    	Map<Id,Opportunity> existingOpportunityMap=new Map<Id,Opportunity>(VisionOpportunityTriggerHelper.extractExistingOpportunites());
    	
    	//Creating a map of invoice number and opportunity Id.
    	for(Id objOpportunityMap: existingOpportunityMap.keyset()){
    		opportunityInvoiceNumberIdMap.put(existingOpportunityMap.get(objOpportunityMap).Invoice_Number__c,objOpportunityMap);
    	}
    	system.debug(opportunityInvoiceNumberIdMap);	
    	
    	//Extracting opportunity line items and creating map of the opportunity id and opportunity line item.
    	List<OpportunityLineItem> opportunityLineItemList=[SELECT Id
    															, Name
    															, OpportunityId
    															, Product2Id
    															, Quantity
    															, TotalPrice
    															, UnitPrice
    															, PricebookEntryId
    														 FROM OpportunityLineItem];
    	for(OpportunityLineItem objLineItem: opportunityLineItemList){
    		if(opportunityIDLineItemMap.containsKey(objLineItem.OpportunityId)){
    			List<OpportunityLineItem> presentLineItems=opportunityIDLineItemMap.get(objLineItem.OpportunityId);
    			presentLineItems.add(objLineItem);
    			opportunityIDLineItemMap.put(objLineItem.OpportunityId,presentLineItems);
    		}
    		else{
    			opportunityIDLineItemMap.put(objLineItem.OpportunityId,new List<OpportunityLineItem>{objLineItem});
    		}
    	}
    	system.debug(opportunityIDLineItemMap);
    	
    	//Extracting contacts and creating a map of contacts along with the accounts they are associated to.    	
    	List<Contact> contactsList=[SELECT Id
    									 , Name
    									 , AccountId
    								  FROM Contact];
    	Map<Id,Id> contactAccountIdMap=new Map<Id,Id>();
    	for(Contact objContact: contactsList){
    		if(objContact.AccountId!=Null){
    			contactAccountIdMap.put(objContact.Id,objContact.AccountId);
    		}
    	}
    	
    	for(Vision_Opportunity__c objNewVision: visionOpportunityRecords){
    		if(opportunityInvoiceNumberIdMap.containsKey(objNewVision.Invoice_Number__c)){
    			Opportunity requiredOpportunity=existingOpportunityMap.get(opportunityInvoiceNumberIdMap.get(objNewVision.Invoice_Number__c));
    			Opportunity objClone=requiredOpportunity.clone(false,false,true,true);
    			objClone.StageName='Closed Won';
    			objClone.Vision_Lookup__c=requiredOpportunity.Id;
 				clonedOpportunityIdList.add(requiredOpportunity.Id);
    			cloneRecords.add(objClone);
    			Opportunity updatedOpportunity=VisionOpportunityTriggerHelper.copyVisionToOpportunity(objNewVision,requiredOpportunity);
    			updatedOpportunityList.add(updatedOpportunity);
    		}
    		else{
    			if(contactAccountIdMap.containsKey(objNewVision.Customer__c)){
    				Opportunity newVisionOpportunity=VisionOpportunityTriggerHelper.copyVisionToOpportunity(objNewVision,new Opportunity());
    				newOpportunities.add(newVisionOpportunity);
    			}
    		}
    	}
    	
    	insert cloneRecords;
    	update updatedOpportunityList;
    	system.debug(newOpportunities);
    	insert newOpportunities;
    	
    	//Activating the validation rule for the stagename of opportunity.
    	objCustomSetting.Activate_Validation_Rule__c=true;
    	update objCustomSetting;	
    	
    	//Adding opportunity line item to the cloned opportunity.
    	for(Opportunity cloneRecord: cloneRecords){
    		if(opportunityIDLineItemMap.containsKey(cloneRecord.Vision_Lookup__c)){
    			system.debug('-----------> opportunity line item');
    			system.debug(opportunityIDLineItemMap.get(cloneRecord.Vision_Lookup__c));
    			system.debug('-------------->cloneRecord.Id'+cloneRecord.Id);
    			List<OpportunityLineItem> relatedLineItemsList=opportunityIDLineItemMap.get(cloneRecord.Vision_Lookup__c);
    			for(OpportunityLineItem objNewLineItem: relatedLineItemsList){
    				OpportunityLineItem cloneLineItem=new OpportunityLineItem();
    				//cloneLineItem.Name=objNewLineItem.Name;
    				//cloneLineItem.Product2Id=objNewLineItem.Product2Id;
    				cloneLineItem.Quantity=objNewLineItem.Quantity;
    				cloneLineItem.TotalPrice=objNewLineItem.TotalPrice;
    				//cloneLineItem.UnitPrice=objNewLineItem.UnitPrice;
    				cloneLineItem.PricebookEntryId=objNewLineItem.PricebookEntryId;
    				cloneLineItem.OpportunityId=cloneRecord.Id;
    				updatedLineItemList.add(cloneLineItem);
    				toBeDeletedLineItemsList.add(objNewLineItem);
    				
    			}
    			/*opportunityIDLineItemMap.get(cloneRecord.Vision_Lookup__c)[0].OpportunityId=cloneRecord.Id;
    			updatedLineItemList.add(opportunityIDLineItemMap.get(cloneRecord.Vision_Lookup__c)[0]);*/
    		}
    	}	
    	
    	objCustomSetting.Activate_Validation_Rule__c=false;
    	update objCustomSetting;
    	
    	system.debug(updatedLineItemList);
    	system.debug(toBeDeletedLineItemsList);
    	
    	insert updatedLineItemList;
    	
    	objCustomSetting.Activate_Validation_Rule__c=true;
    	update objCustomSetting;
    	
    	delete toBeDeletedLineItemsList;								 						   
    }
}