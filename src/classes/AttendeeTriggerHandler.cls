/* 
    Description : To implement Assignment 2 of Apex Trigger (Count no. of Training Sessions of Attendees on Contact)

    Created By : Mayank Mathur(mayank.mathur@fexle.com)

    Created Date : 09/12/2024

    Revision Log : Version 1.0
*/
public class AttendeeTriggerHandler extends TriggerHandler 
{   
    List<Attendee__c> attNewList;
    List<Attendee__c> attOldList;
    Map<Id, Attendee__c> attNewMap;
    Map<Id, Attendee__c> attOldMap;
    
    public AttendeeTriggerHandler()
    {
        attNewList = Trigger.new;
        attOldList = Trigger.old;
        attNewMap = (Map<Id, Attendee__c>) Trigger.newMap;
        attOldMap = (Map<Id, Attendee__c>) Trigger.oldMap;
    }
    
    public override void beforeInsert() 
    {
        				
    }
    public override void beforeUpdate() 
    {
        				
    }
    public override void beforeDelete() 
    {
        				
    }
    public override void afterInsert() 
    {
        countOfTrainingSessions(attNewList, attOldMap);	
    }
    public override void afterUpdate() 
    {
        countOfTrainingSessions(attNewList, attOldMap);			
    }
    public override void afterDelete() 
    {
		countOfTrainingSessions(attOldList, attOldMap);         				
    }
    public override void afterUndelete() 
    {
        countOfTrainingSessions(attNewList, attOldMap);				
    }
    
    /* 
        Purpose : To count number of Training_Sessions__c for a Contact in Attendee__c
        Created By : Mayank Mathur(mayank.mathur@fexle.com)
        Created Date : 09/12/2024
    */
    public static void countOfTrainingSessions(List<Attendee__c> listOfAttendee, Map<Id, Attendee__c> oldMapOfAttendee)
    {   
        System.debug('@@@ New List of Attendees : ' + listOfAttendee);
        
        Set<Id> contactIDs = new Set<Id>();
        
        //Loop to create a set of Contact IDs in the new Records of Attendee__c
        for(Attendee__c att : listOfAttendee)
        {
            if(att.Contact__c != null) 
            {
            	contactIDs.add(att.Contact__c);
            }
            
            if(oldMapOfAttendee != null && oldMapOfAttendee.get(att.Id).Contact__c != null && 
               (att.Contact__c != (oldMapOfAttendee.get(att.Id)).Contact__c))	
            {
                contactIDs.add(oldMapOfAttendee.get(att.Id).Contact__c);
            }	      
        }

        
        
        
        /*
        //Method 1 : By Map and Contact ID
        List<Attendee__c> newAtt = [SELECT Id,Contact__c,Session_Name__c FROM Attendee__c WHERE Contact__c IN : contactIDs];
        
        System.debug(newAtt);
        
        Map<Id,Set<Id>> mapOfContactIdwithSessionIDs = new Map<Id,Set<Id>>();
        
        //Loop to create a Map of Contact IDs as key and corresponding Set of IDs of Training_Session__c as value
        for(Attendee__c att : newAtt)
        {
            if(!mapOfContactIdwithSessionIDs.containsKey(att.Contact__c))
            {  
                mapOfContactIdwithSessionIDs.put(att.Contact__c, new Set<Id>{att.Session_Name__c});  
            }
            
            else
            {
                mapOfContactIdwithSessionIDs.get(att.Contact__c).add(att.Session_Name__c);
            }
        }
        
        System.debug(mapOfContactIdwithSessionIDs);
        
        List<Contact> updatedContactList = new List<Contact>();
        
        //Loop to create List of updated Contact Records to be updated
        for(Id i : contactIDs)
        {
            Contact con = new Contact();
            con.Id = i;
            con.Training_Sessions__c = mapOfContactIdwithSessionIDs.containsKey(i) ? mapOfContactIdwithSessionIDs.get(i).size() : 0;
            updatedContactList.add(con);
        }
		if(updatedContactList)
		{
			update updatedContactList;
		}
		*/
        
        
        
        
        //Method 2 : By Aggregate Query
        Map<Id,Integer> conMap = new Map<Id,Integer>();
        
        if(!contactIDs.isEmpty())
        {
        	AggregateResult[] aggAttendees = [SELECT COUNT_DISTINCT(Session_Name__c) TotalSessions, Contact__c 
                                              FROM Attendee__c 
                                              WHERE Contact__c IN : contactIDs 
                                              GROUP BY Contact__c];    
        	
        	if(!aggAttendees.isEmpty())
        	{
            	for(AggregateResult agg : aggAttendees)
            	{
                	conMap.put((Id) agg.get('Contact__c') , (Integer)agg.get('TotalSessions'));
            	}
        	}
        }
                
        List<Contact> newConList = new List<Contact>();
        
        if(!contactIDs.isEmpty())
        {
            for(Id i : contactIDs)
            {
                Contact con = new Contact();
                con.Id = i;
                if(conMap.containsKey(i))
                {
                    con.Training_Sessions__c = conMap.get(i);
                }
                else
                {
                	con.Training_Sessions__c = 0;  
                }
                newConList.add(con);
            }
	
            if(!newConList.isEmpty())
            {
            	update newConList;    
            }   
        }
    }
}