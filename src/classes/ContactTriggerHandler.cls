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
    }
    public override void beforeUpdate() 
    {
		ContactTriggerHandler.matchContactEmail(conNewList);
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
}