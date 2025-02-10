@isTest
public class AttendeeTriggerHandlerTest 
{
	@testSetup
    static void testSetupMethod()
    {
        List<Contact> conList = new List<Contact>();

        Contact con1 = TestDataFactory.createContact('Contact 1');
        conList.add(con1);
        Contact con2 = TestDataFactory.createContact('Contact 2');
        conList.add(con2);
		
        insert conList;

        List<Training_Session__c> tsList = new List<Training_Session__c>();
        
        Training_Session__c tss1 = TestDataFactory.createTrainingSession('Session 1');
        tsList.add(tss1);
        Training_Session__c tss2 = TestDataFactory.createTrainingSession('Session 2');
        tsList.add(tss2);
        Training_Session__c tss3 = TestDataFactory.createTrainingSession('Session 3');
        tsList.add(tss3);

        insert tsList;
    }
    
    @isTest
    static void insertAttendeeCaseOne()
    {
        //2 Attendee with 1 common Contact and 2 Distinct Training Sessions
        Contact con = [SELECT Id FROM Contact WHERE Name = 'Contact 1'];
        Training_Session__c tss1 = [SELECT Id FROM Training_Session__c WHERE Name = 'Session 1' LIMIT 1];
        Training_Session__c tss2 = [SELECT Id FROM Training_Session__c WHERE Name = 'Session 2' LIMIT 1];        
        
        Attendee__c att1 = new Attendee__c();
        att1.Contact__c = con.Id;
        att1.Session_Name__c = tss1.Id;
        
        Attendee__c att2 = new Attendee__c();
        att2.Contact__c = con.Id;
        att2.Session_Name__c = tss2.Id;
        try
        {
            Test.startTest();
        	insert att1;
        	insert att2;
        	Test.stopTest();        

        	Contact newCon = [SELECT Id,Training_Sessions__c FROM Contact WHERE Name = 'Contact 1' LIMIT 1];

	        Assert.areEqual(2,newCon.Training_Sessions__c,'No. of Training Sessions do not match');
        
        }catch(Exception e)
        {
            System.debug('@@@ Error updating Attendees :=>' + e.getMessage());
        }
        
    }
    
    @isTest
    static void insertAttendeeCaseTwo()
    {
        //2 Attendee with 2 Distinct Contact and 2 Distinct Training Sessions
        Contact con1 = [SELECT Id FROM Contact WHERE Name = 'Contact 1'];
        Contact con2 = [SELECT Id FROM Contact WHERE Name = 'Contact 2'];
        
        Training_Session__c tss1 = [SELECT Id FROM Training_Session__c WHERE Name = 'Session 1' LIMIT 1];
        Training_Session__c tss2 = [SELECT Id FROM Training_Session__c WHERE Name = 'Session 2' LIMIT 1];        
        
        Attendee__c att1 = new Attendee__c();
        att1.Contact__c = con1.Id;
        att1.Session_Name__c = tss1.Id;
        
        Attendee__c att2 = new Attendee__c();
        att2.Contact__c = con2.Id;
        att2.Session_Name__c = tss2.Id;
        
        try
        {
            Test.startTest();
	        insert att1;
    	    insert att2;
        	Test.stopTest();        

	        Contact newCon1 = [SELECT Id,Training_Sessions__c FROM Contact WHERE Name = 'Contact 1' LIMIT 1];
    	    Contact newCon2 = [SELECT Id,Training_Sessions__c FROM Contact WHERE Name = 'Contact 2' LIMIT 1];
        
	        Assert.areEqual(1,newCon1.Training_Sessions__c,'No. of Training Sessions do not match');
    	    Assert.areEqual(1,newCon2.Training_Sessions__c,'No. of Training Sessions do not match');
            
        }catch(Exception e)
        {
            System.debug('@@@ Error updating Attendees :=>' + e.getMessage());
        }
        
    }
	
	@isTest
    static void insertAttendeeCaseThree()
    {
        //2 Attendee with 1 Common Contact and 1 Common Training Sessions
        Contact con = [SELECT Id FROM Contact WHERE Name = 'Contact 1'];
        
        Training_Session__c tss = [SELECT Id FROM Training_Session__c WHERE Name = 'Session 1' LIMIT 1];
        
        Attendee__c att1 = new Attendee__c();
        att1.Contact__c = con.Id;
        att1.Session_Name__c = tss.Id;
        
        Attendee__c att2 = new Attendee__c();
        att2.Contact__c = con.Id;
        att2.Session_Name__c = tss.Id;
        
        try
        {
            Test.startTest();
        	insert att1;
        	insert att2;
        	Test.stopTest();        

	        Contact newCon = [SELECT Id,Training_Sessions__c FROM Contact WHERE Name = 'Contact 1' LIMIT 1];
        
     	 	Assert.areEqual(1,newCon.Training_Sessions__c,'No. of Training Sessions do not match');
            
        }catch(Exception e)
        {
            System.debug('@@@ Error updating Attendees :=>' + e.getMessage());
        }
    }
    
    @isTest
    static void updateAttendeeReparenting()
    {
        List<Attendee__c> attToInsert = new List<Attendee__c>();
        
        List<Training_Session__c> tsList = [SELECT Id FROM Training_Session__c];
        
        List<Contact> contactList = [SELECT Id FROM Contact];
        
        Attendee__c att1 = new Attendee__c();
        att1.Contact__c = contactList[0].Id;
        att1.Session_Name__c = tsList[0].Id;
        attToInsert.add(att1);
        
        Attendee__c att2 = new Attendee__c();
        att2.Contact__c = contactList[0].Id;
        att2.Session_Name__c = tsList[1].Id;
        attToInsert.add(att2);
        
        Attendee__c att3 = new Attendee__c();
        att3.Contact__c = contactList[0].Id;
        att3.Session_Name__c = tsList[2].Id;
        attToInsert.add(att3);
         
        insert attToInsert;
        
        Attendee__c attToUpdate = [SELECT Id, Contact__c, Session_Name__c FROM Attendee__c LIMIT 1];
        attToUpdate.Contact__c = contactList[1].Id;
        
        try{
            Test.startTest();
            update attToUpdate;
            Test.stopTest();
            
            List<Contact> listOfUpdatedContact = [SELECT Id, Training_Sessions__c FROM Contact LIMIT 2];
            
            Assert.areEqual(2 , listOfUpdatedContact[0].Training_Sessions__c, 'Session Count does not match!');
            Assert.areEqual(1 , listOfUpdatedContact[1].Training_Sessions__c, 'Session Count does not match!');
            
        }
        catch(Exception e)
        {
            System.debug('@@@ Error updating Attendees :=>' + e.getMessage());
        }
    }
    
    @isTest
    static void updateAttendeeCountUniqueSessions()
    {
        //Empty List
        List<Attendee__c> attToInsert = new List<Attendee__c>();					

        //List of All Contacts
        List<Contact> contactList = [SELECT Id FROM Contact];						

		//List of All TrainingSessions
        List<Training_Session__c> tsList = [SELECT Id FROM Training_Session__c];	
        
        Attendee__c att1 = new Attendee__c();
        att1.Contact__c = contactList[0].Id;
        att1.Session_Name__c = tsList[0].Id;
        attToInsert.add(att1);
        
        Attendee__c att2 = new Attendee__c();
        att2.Contact__c = contactList[1].Id;
        att2.Session_Name__c = tsList[0].Id;
        attToInsert.add(att2);
        
        Attendee__c att3 = new Attendee__c();
        att3.Contact__c = contactList[1].Id;
        att3.Session_Name__c = tsList[1].Id;
        attToInsert.add(att3);
        
        //Inserted new List of Attendee
        insert attToInsert;
        
        Attendee__c attToUpdate = [SELECT Id, Contact__c, Session_Name__c FROM Attendee__c LIMIT 1];
        
        attToUpdate.Contact__c = contactList[1].Id;
        
        try{
            Test.startTest();
            update attToUpdate;
            Test.stopTest();
            
            List<Contact> listOfUpdatedContact = [SELECT Id, Training_Sessions__c FROM Contact LIMIT 2];
            
            Assert.areEqual(0 , listOfUpdatedContact[0].Training_Sessions__c, 'Session Count does not match');
            Assert.areEqual(2 , listOfUpdatedContact[1].Training_Sessions__c, 'Session Count does not match');
            
        }
        catch(Exception e)
        {
            System.debug('@@@ Error updating Attendees :=>' + e.getMessage());
        }
    }
    
    @isTest
    static void updateAttendeeCaseTwo()
    {
        //Empty List
        List<Attendee__c> attToInsert = new List<Attendee__c>();					

        //List of All Contacts
        List<Contact> contactList = [SELECT Id FROM Contact];						

		//List of All TrainingSessions
        List<Training_Session__c> tsList = [SELECT Id FROM Training_Session__c];	
        
        Attendee__c att1 = new Attendee__c();
        att1.Contact__c = contactList[0].Id;
        att1.Session_Name__c = tsList[0].Id;
        attToInsert.add(att1);
        
        Attendee__c att2 = new Attendee__c();
        att2.Contact__c = contactList[1].Id;
        att2.Session_Name__c = tsList[0].Id;
        attToInsert.add(att2);
        
        Attendee__c att3 = new Attendee__c();
        att3.Contact__c = contactList[1].Id;
        att3.Session_Name__c = tsList[1].Id;
        attToInsert.add(att3);
        
        //Inserted new List of Attendee
        insert attToInsert;
        
        Attendee__c attToUpdate = [SELECT Id, Contact__c, Session_Name__c FROM Attendee__c LIMIT 1];
        
        attToUpdate.Contact__c = contactList[1].Id;
        
        try{
            Test.startTest();
            update attToUpdate;
            Test.stopTest();
            
            List<Contact> listOfUpdatedContact = [SELECT Id, Training_Sessions__c FROM Contact LIMIT 2];
            
            Assert.areEqual(0 , listOfUpdatedContact[0].Training_Sessions__c, 'Session Count does not match');
            Assert.areEqual(2 , listOfUpdatedContact[1].Training_Sessions__c, 'Session Count does not match');
            
        }
        catch(Exception e)
        {
            System.debug('@@@ Error updating Attendees :=>' + e.getMessage());
        }
    }
    
    @isTest
    static void deleteCaseOne()
    {
        //Empty List
        List<Attendee__c> attToInsert = new List<Attendee__c>();					

        //List of All Contacts
        List<Contact> contactList = [SELECT Id FROM Contact];						

		//List of All TrainingSessions
        List<Training_Session__c> tsList = [SELECT Id FROM Training_Session__c];	
        
        Attendee__c att1 = new Attendee__c();
        att1.Contact__c = contactList[0].Id;
        att1.Session_Name__c = tsList[0].Id;
        attToInsert.add(att1);
        
        Attendee__c att2 = new Attendee__c();
        att2.Contact__c = contactList[1].Id;
        att2.Session_Name__c = tsList[1].Id;
        attToInsert.add(att2);
        
        Attendee__c att3 = new Attendee__c();
        att3.Contact__c = contactList[1].Id;
        att3.Session_Name__c = tsList[2].Id;
        attToInsert.add(att3);
        
        //Inserted new List of Attendee
        insert attToInsert;
        
        List<Attendee__c> attToBeDeleted= [SELECT Id FROM Attendee__c LIMIT 2];
        
        try{
            Test.startTest();
            delete attToBeDeleted;
            Test.stopTest();
            
            List<Contact> listOfUpdatedContact = [SELECT Id, Training_Sessions__c FROM Contact LIMIT 2];
            
            Assert.areEqual(0 , listOfUpdatedContact[0].Training_Sessions__c, 'Session Count does not match');
            Assert.areEqual(1 , listOfUpdatedContact[1].Training_Sessions__c, 'Session Count does not match');
        }
        catch(Exception e)
        {
            System.debug('@@@ Error updating Attendees :=>' + e.getMessage());
        }
    }
    
    @isTest
    static void undeleteCaseOne()
    {
        //Empty List
        List<Attendee__c> attToInsert = new List<Attendee__c>();					

        //List of All Contacts
        List<Contact> contactList = [SELECT Id FROM Contact];						

		//List of All TrainingSessions
        List<Training_Session__c> tsList = [SELECT Id FROM Training_Session__c];	
        
        Attendee__c att1 = new Attendee__c();
        att1.Contact__c = contactList[0].Id;
        att1.Session_Name__c = tsList[0].Id;
        attToInsert.add(att1);
        
        Attendee__c att2 = new Attendee__c();
        att2.Contact__c = contactList[1].Id;
        att2.Session_Name__c = tsList[1].Id;
        attToInsert.add(att2);
        
        Attendee__c att3 = new Attendee__c();
        att3.Contact__c = contactList[1].Id;
        att3.Session_Name__c = tsList[2].Id;
        attToInsert.add(att3);
        
        //Inserted new List of Attendee
        insert attToInsert;
        
        List<Attendee__c> attToDelete = new List<Attendee__c>();
        attToDelete.add(att1);
        attToDelete.add(att2);
		
        //Deleted list of Attendees
        delete attToDelete;
        
        //List<Training_Session__c> tsDeletedList = [SELECT Id FROM Training_Session__c LIMIT 2];
        try
        {
            Test.startTest();
            undelete attToDelete;
            Test.stopTest();
            
            List<Contact> newConList = [SELECT Id,Training_Sessions__c FROM Contact LIMIT 2];
            
            Assert.areEqual(1 , newConList[0].Training_Sessions__c, 'Session Count does not match');
            Assert.areEqual(2 , newConList[1].Training_Sessions__c, 'Session Count does not match');
        }
        catch(Exception e)
        {
            System.debug('@@@ Error updating Attendees :=>' + e.getMessage());
        }
    }
}