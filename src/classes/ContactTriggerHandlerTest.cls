@isTest
public class ContactTriggerHandlerTest 
{
	@testSetup
    public static void testSetupMethod()
    {
        List<Account> accList = new List<Account>();

        //Account 1 with Domain
        Account acc1 = TestDataFactory.createAccount('Account 1');
        acc1.Domain__c = '@domain.com';
		accList.add(acc1);
        
        //Account 2 without Domain
        Account acc2 = TestDataFactory.createAccount('Account 2');
		accList.add(acc2);
        
        //Account 3 with different Domain
        Account acc3 = TestDataFactory.createAccount('Account 3');
        acc3.Domain__c = '@gmail.com';
        accList.add(acc3);
        
        insert accList;
    }
    @isTest
    static void testContactWithAccountWithDomain()
    {
        //New Contact with Account(with Domain) and correct Email
        Account acc = [SELECT Id FROM Account WHERE Name = 'Account 1' LIMIT 1];
        Contact con = new Contact(LastName = 'Contact 1', AccountId = acc.Id, Email = 'test@domain.com');
        try
        {
        	Test.startTest();
    	    insert con;							//No Error Expected
        	Test.stopTest();
        }catch(Exception e)
        {
            System.debug('@@@ Error Inserting Records => ' + e.getMessage());
            Assert.areEqual(true, e.getMessage().contains(ContactTriggerHandler.errorMessage), 'Unexpected Error Occurred');
        }
        
        Contact newCon = [SELECT Id, LastName, AccountId, Email FROM Contact WHERE LastName = 'Contact 1' LIMIT 1];
        
        Assert.areEqual(con, newCon, 'Domain did not match.');
    }
    
    @isTest
    static void testContactWithAccountWithoutDomain()
    {
     	//New Contact with Account(with Domain) and without Email
     	Account acc = [SELECT Id FROM Account WHERE Name = 'Account 1' LIMIT 1];
		Contact con = new Contact(LastName = 'Contact 2', AccountId = acc.Id);
        try
        {
        	Test.startTest();
    	    insert con;							//No Error Expected
        	Test.stopTest();
        }catch(Exception e)
        {
            System.debug('@@@ Error Inserting Records => ' + e.getMessage());
            Assert.areEqual(true, e.getMessage().contains(ContactTriggerHandler.errorMessage), 'Unexpected Error Occurred');
        }
		
       	Contact newCon = [SELECT Id, LastName, AccountId, Email FROM Contact WHERE LastName = 'Contact 2' LIMIT 1];
        
        Assert.areEqual(con, newCon, 'Domain did not match');
    }

    @isTest
    static void testContactWithoutAccountWithDomain()
    {
        //New Contact without Account(with Domain)
        Contact con = new Contact(LastName = 'Contact 3', Email = 'test@gmail.com');
        try
        {
        	Test.startTest();
    	    insert con;							//No Error Expected
        	Test.stopTest();
        }catch(Exception e)
        {
            System.debug('@@@ Error Inserting Records => ' + e.getMessage());
            Assert.areEqual(true, e.getMessage().contains(ContactTriggerHandler.errorMessage), 'Unexpected Error Occurred');
        }
        
        Contact newCon = [SELECT Id, LastName, AccountId, Email FROM Contact WHERE LastName = 'Contact 3' LIMIT 1];
        
        Assert.areEqual(con, newCon, 'Domain did not match');
    }
    @isTest
    static void testContactWithAccountWithWrongDomain()
    {
        //New Contact with Account(with Domain) and Wrong Email
       	Account acc = [SELECT Id FROM Account WHERE Name = 'Account 1' LIMIT 1];
        Contact con = new Contact(LastName = 'Contact 4', AccountId = acc.Id, Email = 'test@gmail.com');
        try
        {	
            Test.startTest();
        	insert con;							//error Expected
        	Test.stopTest();
        
        }catch(Exception e)
        {
            System.debug(e.getMessage());
            Assert.areEqual(true, e.getMessage().contains(ContactTriggerHandler.errorMessage), 'Unexpected Error Occurred');
        }
    }
    @isTest
    static void testContactWithEmptyAccountWithWrongDomain()
    {
        Account acc = [SELECT Id FROM Account WHERE Name = 'Account 2' LIMIT 1];
        Contact con = new Contact(LastName = 'Contact 5', AccountId = acc.Id, Email = 'test@gmail.com');        
        try
        {
        	Test.startTest();
    	    insert con;							//No Error Expected
        	Test.stopTest();
        }catch(Exception e)
        {
            System.debug('@@@ Error Inserting Records => ' + e.getMessage());
            Assert.areEqual(true, e.getMessage().contains(ContactTriggerHandler.errorMessage), 'Unexpected Error Occurred');
        }
        
        Contact newCon = [SELECT Id, LastName, AccountId, Email FROM Contact WHERE LastName = 'Contact 5' LIMIT 1];
        
        Assert.areEqual(con, newCon, 'Domain did not match');
    }
    
    @isTest
    static void updateNewAccountWrongDomain()
    {
        //Update Contact with New Email but Wrong Domain
        List<Account> accList = [SELECT Id FROM Account LIMIT 3];        
        Contact conInserted = new Contact(LastName = 'Contact 6', AccountId = accList[0].Id, Email = 'test@domain.com');

        //Contact Inserted
        insert conInserted;        
        
        Contact conUpdated = [SELECT Id,Email FROM Contact WHERE LastName = 'Contact 6' LIMIT 1];
        conUpdated.Email = 'test@gmail.com';
        try
        {
        	Test.startTest();
    	    update conUpdated;						//error Expected
        	Test.stopTest();
        }catch(Exception e)
        {
            System.debug('@@@ Error Inserting Records => ' + e.getMessage());
            Assert.areEqual(true, e.getMessage().contains(ContactTriggerHandler.errorMessage), 'Unexpected Error Occurred');
        }
    }
    
    @isTest
    static void updateNewAccountRightDomain()
    {
        //Update Contact with New Account(with Domain) and Right Email
        List<Account> accList = [SELECT Id,Domain__c FROM Account LIMIT 3];
        Contact conInserted = new Contact(LastName = 'Contact 7', AccountId = accList[0].Id, Email = 'test@domain.com');

        insert conInserted;
        
        Contact conUpdated = [SELECT Id,Email,AccountId FROM Contact WHERE LastName = 'Contact 7' LIMIT 1];
        conUpdated.AccountId = accList[2].Id;
        conUpdated.Email = 'test@gmail.com';
		
        try
        {
            Test.startTest();
            update conUpdated;					//No Error Expected
            Test.stopTest();
        }catch(Exception e)
        {
            System.debug('@@@ Error Inserting Records => ' + e.getMessage());
            Assert.areEqual(true, e.getMessage().contains(ContactTriggerHandler.errorMessage), 'Unexpected Error Occurred');
        }
        
        Contact newCon = [SELECT Id,Email,AccountId FROM Contact WHERE LastName = 'Contact 7' LIMIT 1];
        
        Assert.areEqual(conUpdated, newCon, 'Domain did not match');
    }
}