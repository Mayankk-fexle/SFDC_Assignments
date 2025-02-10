/* 
    Description : To implement Apex Assignment on Triggers(Check if the Email in new Contacts match with the Domain__c of the associated Accounts)

    Created By : Mayank Mathur(mayank.mathur@fexle.com)

    Created Date : 04/12/2024

    Revision Log : Version 1.0
*/
public with Sharing class ContactTriggerHandler extends TriggerHandler
{
    List<Contact> conNewList;
    List<Contact> conOldList;
    Map<Id, Contact> conNewMap;
    Map<Id, Contact> conOldMap;
    
    public static String errorMessage = 'Email does not match the Related Account Domain';
    
    public static String errMsg = 'RecordID does not exist, Please enter a valid RecordID';

    public ContactTriggerHandler()
    {
        conNewList = Trigger.new;
        conOldList = Trigger.old;
        conNewMap = (Map<Id, Contact>) Trigger.newMap;
        conOldMap = (Map<Id, Contact>) Trigger.oldMap;
    }
	
    public override void beforeInsert() 
    {
		ContactTriggerHandler.matchContactEmail(conNewList);
        ContactTriggerHandler.populateObjectAndPicklist(conNewList);
    }
    public override void beforeUpdate() 
    {
		ContactTriggerHandler.matchContactEmail(conNewList);
        ContactTriggerHandler.populateObjectAndPicklist(conNewList);
    }
    /*
    public override void beforeDelete() 
    {
		
    }
    public override void afterInsert() 
    {
        
    }
    public override void afterUpdate() 
    {

    }
    public override void afterDelete() 
    {

    }
    public override void afterUndelete() 
    {

    }
	*/

    
    /* 
        Purpose : Trigger Logic(To check if the Email in new Contacts match with the Domain__c of the associated Accounts)
        Created By : Mayank Mathur(mayank.mathur@fexle.com)
        Created Date : 04/12/2024
    */
    
    public static void matchContactEmail(List<Contact> newContactsList)
    {
        Set<Id> accIdSet = new Set<Id>();

        //Iteration to add Account Ids in the set that are associated with new Contacts inserted
        for(Contact con : newContactsList)
        {
            accIdSet.add(con.AccountId);
        }
		
        Map<Id,Account> accMapForNewContacts = new Map<Id,Account>([SELECT Id,Domain__c FROM Account WHERE Id IN : accIdSet]);
        
        //Iteration to check Email in each instance of Contacts with the Domain of it's associated Account
        for(Contact con : newContactsList)
        {    
            if(con.AccountId!=null && String.isNotEmpty(con.Email) &&  
               accMapForNewContacts.get(con.AccountId).Domain__c!=null && 
               (!con.Email.endsWith((accMapForNewContacts.get(con.AccountId).Domain__c))))
            {
				con.Email.addError(errorMessage);
            }
        }
    }
    
    /* 
        Purpose : Trigger Logic(To populate the picklist_fields__c & Object_Name__c with the RecordID__c custom field)
        Created By : Mayank Mathur(mayank.mathur@fexle.com)
        Created Date : 02/01/2025
    */ 
    public static void populateObjectAndPicklist(List<Contact> conList)
    {
        //Check if new records are present
        if(!conList.isEmpty())
        {
            for(Contact con : conList)
            {
                //Check if current record has RecordID or not
                if(!String.isEmpty(con.RecordID__c)) 
                { 
                    try
                    {
                        if(Id.valueOf(con.RecordID__c).getSObjectType() != null)
                        {
                            //Store Record ID in variable of type Id
                            Id recordId;
                            recordId = Id.valueOf(con.RecordID__c); 
                            
                            //Get Object Name of that Id
                            SobjectType SObjectName = recordId.getSObjectType();
                            
                            //List to store picklist field names
                            List<string> picklistfields = new List<string>();
                            
                            //Get all Metadata of the particular Object Name
                            Schema.DescribeSObjectResult sObjectDescribe = SObjectName.getDescribe(); 
                            
                            // Iterate through the fields of the sObject 
                            for (Schema.SObjectField field : sObjectDescribe.fields.getMap().values()) 
                            { 
                                //Get information about the current field value
                                Schema.DescribeFieldResult fieldDescribe = field.getDescribe(); 
                                
                                // Check if the field is a picklist 
                                if (fieldDescribe.getType() == Schema.DisplayType.Picklist) 
                                { 
                                    // Print the picklist field name 
                                    picklistfields.add(fieldDescribe.getName());
                                } 
                            }
                            
                            //Updating value of Object in the field
                            con.Object_Name__c = ((Id)recordId).getSobjectType().getDescribe().getName();
                            
                            //Adding picklist field names in seperate lines
                            if(!picklistfields.isEmpty())
                            {
                                con.Picklist_Fields__c = '';
                                for(String val : picklistfields)
                                {
                                    con.Picklist_Fields__c += val + '\n';       
                                }
                            }
                            //If there are no picklist fields, set the field empty
                            else
                            {
                                con.Picklist_Fields__c = '';
                            }
                    	}
                    }
                    catch(Exception e)
                    {
                        con.addError(errMsg);
                    }
                }
            }
        }
    }
}