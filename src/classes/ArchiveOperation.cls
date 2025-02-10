/* 
    Description : Generic Batch Class to delete records using Metadata(Dynamic Apex Assignment 2)

    Created By : Mayank Mathur(mayank.mathur@fexle.com)

    Created Date : 02/01/2025

    Revision Log : Version 1.0
*/
public class ArchiveOperation implements Database.Batchable<sObject>, Database.stateful 
{
    public String query;
    Set<Id> deletedRecordIds = new Set<Id>();
    String csvHeaders;
    List<String> csvData = new List<String>();
    List<String> fieldNames = new List<String>();
    List<String> rowData = new List<String>();
	
    //to be used in test class
    @testVisible private static Integer emailSent = 0;

    //retrieve Metadata Records
    Archive_Config__mdt accInfo = Archive_Config__mdt.getInstance('Account_Query');

    public Database.QueryLocator start(Database.BatchableContext bc) 
    {
        //return null if Metadata doesn't exist
        if (accInfo == null) 
        {
            System.debug('Metadata record not found.');
            return Database.getQueryLocator('');
        }

        query = 'SELECT Id, Name, CreatedDate, Domain__c FROM ' + accInfo.Label__c +
                ' WHERE ' + accInfo.Filter__c +
                ' AND CreatedDate <= LAST_N_MONTHS:' + accInfo.Duration__c;
        
        // Build headers dynamically
        DescribeSObjectResult describeResult = Schema.getGlobalDescribe().get(accInfo.Label__c).getDescribe();
        
        //Iteration to check all fields and add the specific ones
        for(String field : describeResult.fields.getMap().keySet())
        {
         	if(field == 'Id' || field == 'Name' || field == 'Domain__c' || field == 'CreatedDate')
            {
                fieldNames.add(field);
            }
        }

        csvHeaders = String.join(fieldNames, ',');

        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext bc, List<SObject> sObjectList) 
    {
        if (sObjectList.isEmpty()) 
        {
            return;
        }

        // Add the headers in CSV file(constructed in the start method)
        csvData.add(csvHeaders); 
		
        //Loop to add data in CSV
        for (SObject record : sObjectList) 
        {   
            //add Record IDs to be deleted
            deletedRecordIds.add(record.Id);
            
            //Clear row each time loop starts ; to avoid duplicacy
            rowData.clear();

            for (String field : fieldNames) 
            {
                //Extracts value of each field from the record
                rowData.add(String.valueOf(record.get(field)));
            }
			//add each row as record in CSV file
            csvData.add(String.join(rowData, ','));	            
        }
		
        //CSV converted as Blob object so as to use as an argument
        Blob csvBlob = Blob.valueOf(String.join(csvData, '\n'));
        
        //CSV file created as an Attachment
        Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
        attachment.setFileName('SObject_Records.csv');
        attachment.setBody(csvBlob);

        //Email message created with attachment
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setSubject('CSV Export of SObject Records to be deleted');
        email.setToAddresses(new String[] { 'atworkmayank@gmail.com' });
        email.setPlainTextBody('Please find the attached CSV file of the deleted records.');
        email.setFileAttachments(new Messaging.EmailFileAttachment[] { attachment });
		
        //Mail sent to the user
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
        
        //Getting number of mails sent in a transaction
        emailSent = Limits.getEmailInvocations();
    }

    public void finish(Database.BatchableContext bc) 
    {
        if (!deletedRecordIds.isEmpty()) 
        {
            try 
            {
                delete Database.query('SELECT Id FROM ' + accInfo.Label__c + ' WHERE Id IN :deletedRecordIds');
            } 
            catch (Exception e) 
            {
                System.debug('Failed to delete records: ' + e.getMessage());
            }
        }
        System.debug('Batch job finished successfully.');
    }
}