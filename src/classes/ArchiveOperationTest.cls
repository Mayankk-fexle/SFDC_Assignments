/* 
    Description : Test Class for Generic Batch Class to delete records using Metadata(Dynamic Apex Assignment 2)

    Created By : Mayank Mathur(mayank.mathur@fexle.com)

    Created Date : 02/01/2025

    Revision Log : Version 1.0
*/

@isTest
public class ArchiveOperationTest 
{
    @isTest(seeAllData=true)
    static void testBatchExecutionWithExistingRecords() 
    { 
        // Execute batch
        Test.startTest();
        	ArchiveOperation batch = new ArchiveOperation();
        	Database.executeBatch(batch);
        Test.stopTest();
		
        // Query metadata for configuration
        Archive_Config__mdt config = [SELECT Label__c, Filter__c, Duration__c 
                                      FROM Archive_Config__mdt 
                                      WHERE Developer_Name__c = 'Account' 
                                      LIMIT 1];
        
        // Query existing records dynamically based on metadata
        String dynamicQuery = 'SELECT Id, Name, CreatedDate FROM ' + config.Label__c +
                              ' WHERE ' + config.Filter__c +
                              ' AND CreatedDate <= LAST_N_MONTHS:' + config.Duration__c;
          
        List<SObject> remainingRecords = Database.query(dynamicQuery);

        //Check if records were deleted
        Assert.areEqual(0, remainingRecords.size(), 'All matching records should have been deleted.');

		// Check if email was sent
        Assert.areEqual(1, ArchiveOperation.emailSent, 'All matching records should have been deleted.');
    }
}