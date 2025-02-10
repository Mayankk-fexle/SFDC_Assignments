@isTest
public class ContactTriggerHandlerTest 
{
	@testSetup
    public static void setupTestData()
    {
        /*. ================  Test Data for Trigger 1 : Matching Contact Email and Account Domain =================	*/
        
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
        
        /*. ================  Test Data for Trigger 2 : ObjectName and Picklist Fields with RecordID ==============	*/
        
        // Create a test Account with picklist fields
        Account testAccount = TestDataFactory.createAccount('Test Account');
        insert testAccount;

        // Create a custom object record with no picklist fields
        Training_Session__c testobj = TestDataFactory.createTrainingSession('Test Session');
        insert testobj;
    }

    
    /*. ================  Test Cases for Trigger 1 : Matching Contact Email and Account Domain =================	*/
    
    
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
    
    
    /* ================ Test Cases for Trigger 2 : ObjectName and Picklist Fields with RecordID =============== */
    
    
    @isTest
    static void testValidRecordId() 
    {
        Account acc = [SELECT Id FROM Account WHERE Name = 'test Account' LIMIT 1];
        
        Contact validIDContact = TestDataFactory.createContact('Valid ID Contact'); 
        validIDContact.RecordID__c = acc.Id;        
        
        Test.startTest();
        insert validIDContact;
        Test.stopTest();
        
        Contact con = [SELECT Id, RecordID__c, Object_Name__c, Picklist_Fields__c FROM Contact LIMIT 1];
        
        // Assertions for a valid RecordID
        Assert.areEqual(con.RecordID__c, acc.Id, 'RecordID__c should match the valid Account ID');
        Assert.areEqual('Account', con.Object_Name__c, 'Object_Name__c should be "Account" for valid RecordID');
        Assert.isNotNull(con.Picklist_Fields__c, 'Picklist_Fields__c should be populated for valid RecordID');
    }

    @isTest
    static void testInvalidRecordId() 
    {
        Contact invalidIDContact = TestDataFactory.createContact('Invalid ID Contact');
        invalidIDContact.RecordID__c = '001INVALIDID123';
        
        try 
        {
            Test.startTest();
            insert invalidIDContact;		//Error Expected
            Test.stopTest();

            //Check if error didn't occur as expected
            Assert.fail('Expected an error for invalid RecordID, but no error was thrown.');
        }
        catch (DmlException e) 
        {
            Assert.isTrue(e.getMessage().contains(ContactTriggerHandler.errMsg), 'Expected error message for invalid RecordID does not match.');
        }
    }

    @isTest
    static void testValidCustomObjectWithoutPicklistFields() 
    {
        Training_Session__c testobj = [SELECT Id FROM Training_Session__c WHERE Name = 'Test Session' LIMIT 1];
		
        Contact validCustomObjectContact = TestDataFactory.createContact('Valid Custom Object Contact');
        validCustomObjectContact.RecordID__c = testobj.Id;
        
        Test.startTest();
        insert validCustomObjectContact;
		Test.stopTest();

        Contact con = [SELECT Id, RecordID__c, Object_Name__c, Picklist_Fields__c FROM Contact LIMIT 1];
        
        // Assertions for valid RecordID with no picklist fields
        Assert.areEqual('Training_Session__c', con.Object_Name__c, 'Object_Name__c should be "Training_Session__c" for the valid Custom Object ID.');            
        Assert.areEqual(null, con.Picklist_Fields__c, 'Picklist_Fields__c should be empty when the object has no picklist fields.');
    } 
    
    @isTest
    static void updateValidToInvalidID() 
    {
        Account acc = [SELECT Id FROM Account WHERE Name = 'test Account' LIMIT 1];
        
        Contact validIDContact = TestDataFactory.createContact('Valid ID Contact'); 
        validIDContact.RecordID__c = acc.Id;        
        
        insert validIDContact;
        
        Contact updatedContact = [SELECT Id FROM Contact WHERE LastName = 'Valid ID Contact' LIMIT 1];
        updatedContact.RecordID__c = '001INVALIDID123';
        
        Test.startTest();
        // Attempt update to validate error handling for invalid RecordID
        try 
        {
            update updatedContact;
            Assert.fail('Expected an error for invalid RecordID, but no error was thrown.');
        }
        catch (DmlException e) 
        {
            Assert.isTrue(e.getMessage().contains(ContactTriggerHandler.errMsg), 'Expected error message for invalid RecordID does not match.');
        }
        Test.stopTest();
    }
    
    @isTest
    static void updateEmptyToValidPicklist() 
    {
        Account acc = [SELECT Id FROM Account WHERE Name = 'test Account' LIMIT 1];
        
        Contact validIDContact = TestDataFactory.createContact('Valid ID Contact'); 
        validIDContact.RecordID__c = acc.Id;        
        
        insert validIDContact;
        
        Training_Session__c tss = [SELECT Id FROM Training_Session__c WHERE Name = 'Test Session'];
        
        Contact updatedContact = [SELECT Id FROM Contact WHERE LastName = 'Valid ID Contact' LIMIT 1];
        updatedContact.RecordID__c = tss.Id;

        Test.startTest();
        update updatedContact;
        Test.stopTest();
        
        Contact con = [SELECT Id, RecordID__c, Object_Name__c, Picklist_Fields__c FROM Contact LIMIT 1];
        
        // Assertions for valid RecordID with no picklist fields
        Assert.areEqual('Training_Session__c', con.Object_Name__c, 'Object_Name__c should be "Training_Session__c" for the valid Custom Object ID.');            
        Assert.areEqual(null, con.Picklist_Fields__c, 'Picklist_Fields__c should be empty when the object has no picklist fields.');

    }
}