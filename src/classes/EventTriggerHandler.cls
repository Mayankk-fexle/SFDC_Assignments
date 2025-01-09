public class EventTriggerHandler 
{
	public static void rollUpOnAccount(List<Event> eventList, Map<Id,Event> eventNewMap)
    {        
        List<Id> accOpenIds = new List<Id>();
        
        List<Id> accClosedIds = new List<Id>();
        
        List<Id> accAllIDs = new List<ID>();
        
        if(!eventList.isEmpty())
        {
            for(Event event : eventList)
            {
                if(event.AccountId != null)
                {
                    accAllIDs.add(event.AccountId);
                    
                    if(event.Status__c == 'Closed')
                    {
                        accOpenIds.add(event.AccountId);
                    }
                    if(event.Status__c == 'Open')
                    {
                        accClosedIds.add(event.AccountId);
                    }
                    
                }
            }
        }
        
        System.debug('@@@ List of Open Ids = ' + accOpenIds);
        System.debug('@@@ List of Closed Ids = ' + accClosedIds);
        System.debug('@@@ List of All WhatIds = ' + accAllIDs);

        Map<Id, Integer> accAllMap = new Map<Id,Integer>();

        System.debug('@@@ Aggregate result = ' + [SELECT AccountId, Count(Id) TaskCount FROM Task WHERE AccountId IN : accAllIDs GROUP BY AccountId]);
        
        for(AggregateResult aggresult : [SELECT AccountId, COUNT(Id) TaskCount 
										FROM Task 
										WHERE AccountId IN :accAllIDs 
										GROUP BY AccountId
										])
        {
            accAllMap.put((Id)aggresult.get('AccountId'), (Integer)aggresult.get('TaskCount'));
        }
        
        System.debug('@@@ Acc Map with Count = ' + accAllMap);
        
        List<Account> accToUpdate = new List<Account>();
        
        if(!accAllIds.isEmpty())
        {
            for(Id accID : accAllIds)
        	{
            	Account acc = new Account();
            	acc.ID = accID;
            	acc.Total_Activities__c = accAllMap.get(accID);
            	accToUpdate.add(acc);
        	}
        }

        System.debug('@@@ acc to update = ' + accToUpdate);
        
        if(!accToUpdate.isEmpty())
        {
            update accToUpdate;
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        /*
        for(Account acc : [SELECT Id FROM Account])
        {
        	accIDs.add(acc.Id);    
        }

        SObjectType currentType = Schema.getGlobalDescribe().get('Account');

        if(!eventList.isEmpty())
        {
            for(Event event : eventList)
            {
                if(accIDs.contains(event.WhatId))
                {
                    listOfWhatIds.add(event.WhatId);
                    
                    if(event.Status__c == 'Closed')
                    {
                        OpenWhatIds.add(event.WhatId);
                    }
                    if(event.Status__c == 'Open')
                    {
                        ClosedWhatIds.add(event.WhatId);
                        event.
                    }
                }
            }
        }
        
        List<Account> accList = [SELECT Id FROM Account WHERE Id IN : listOfWhatIds];
        */
        
    }
}