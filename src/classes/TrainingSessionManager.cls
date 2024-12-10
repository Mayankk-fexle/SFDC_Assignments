/* 
    Description : To implement Assignment 2 of Apex Basics (DML statements, SOQL queries)

    Created By : Mayank Mathur(mayank.mathur@fexle.com)

    Created Date : 27/11/2024

    Revision Log : Version 1.0
*/
public with sharing class TrainingSessionManager {
    
   /* 
        Purpose : To insert record in Training_Session__c Object
        Created By : Mayank Mathur(mayank.mathur@fexle.com)
        Created Date : 27/11/2024
    */

	// TASK1 - Read, Update, Insert, Delete

   	public static void createTrainingRecord() {
        try{
        	List<RecordType> workshopRecordType = [SELECT Name,ID from RecordType WHERE sObjectType = 'Training_Session__c'];
	        List<Training_Session__c> l1 = new List<Training_Session__c>();
    	    for(Integer i=1 ; i<=5 ; i++)
        	{
            	Training_Session__c tss1 = new Training_Session__c();
	            tss1.Name = 'New '+ i;
    	        if((Math.mod(i,2))==0)
        	    {
            	    tss1.Location__c = 'Home';
	            }
    	        else
        	    {
            	    tss1.Location__c = 'Office';
	            }
    	        tss1.RecordTypeId = workshopRecordType[2].Id;
        	    l1.add(tss1);
	        }
        
        	insert l1;             //DML statement to insert record stored in instance 'ts'
        }catch(Exception e){
            System.debug('Record Insert Failure ' + e.getMessage());
        }
    }
   
    /* 
        Purpose : To update record in Training_Session__c Object
        Created By : Mayank Mathur(mayank.mathur@fexle.com)
        Created Date : 27/11/2024
    */
    public static void updateTrainingRecord() {
        try{
        	List<Training_Session__c> listUpdate = [SELECT Name FROM Training_Session__c WHERE Name='Ishan'];
	        for(Training_Session__c tss2 : listUpdate)
    	    {
        	    tss2.Name = 'Ice Breaking Session';
	        }
    	    update listUpdate;             //DML statement to update record with changes stored in instance 'record2'
	    
        }catch(Exception e){
            System.debug('Record Update Failure ' + e.getMessage());
       	}
    }
   
   /* 
        Purpose : To delete record in Training_Session__c Object
        Created By : Mayank Mathur(mayank.mathur@fexle.com)
        Created Date : 27/11/2024
    */
    public static void deleteTrainingRecord() {
        try{
            
        	//Training_Session__C record3 = new Training_Session__C(Id = 'a02Qy000005p3tpIAA');
	        //delete record3;             //DML Query to delete record stored in instance 'record3'
    	    List<Training_Session__c> listdel = new List<Training_Session__c>([SELECT Id FROM Training_Session__c WHERE Name Like 'New%' OR Name Like 'Test%' Or Name Like 'User%']);
        	delete listdel;
		}catch(Exception e){
            System.debug('Record Delete Failure ' + e.getMessage());
       	}
    }
   
   /* 
        Purpose : To read record in Training_Session__c Object
        Created By : Mayank Mathur(mayank.mathur@fexle.com)
        Created Date : 28/11/2024
    */
    public static void readTrainingRecord() {
        try{    
        	
            List<Training_Session__C> record4 = [SELECT Name, Session_Date__c, Employee_ID__c, Webinar_Link__c FROM Training_Session__C WHERE Name = 'Data Science']; 
        	System.debug(record4);
		
        }catch(Exception e){
            System.debug('Record Read Failure ' + e.getMessage());
       	}
    }
    
    //Task 2 = Add attendees to training session ensuring each attendee is only added once
    /* 
        Purpose : Task 2 => To add unique Attendees__c to Training_Session__c 
        Created By : Mayank Mathur(mayank.mathur@fexle.com)
        Created Date : 28/11/2024
    */
    public static void apexTask2(){
        try{
            Set<Training_Session__c> tsRecordId = new Set<Training_Session__c>([SELECT Id FROM Training_Session__c Limit 5]);
        	List<Attendee__c> addList = new List<Attendee__c>();
            for(Training_Session__c tss : tsRecordId)
        	{
            	Attendee__c att = new Attendee__c();
            	att.Name = 'Test User';
            	att.Session_Name__c = tss.Id;
            	addList.add(att);
        	}        	
            insert addList;        
        }catch(Exception e){
            System.debug('Update Failure ' + e.getMessage());
        }
    }
    
    //Task 3 = Add attendees to training session ensuring each attendee is only added once
    /* 
        Purpose : Task 3 => Create enum and use it in your code
        Created By : Mayank Mathur(mayank.mathur@fexle.com)
        Created Date : 29/11/2024
    */
    public enum TypesOfRecord {Webinar, Workshop, Seminar}
    
    public static void enumDemo()
    {
        try{
            Integer webinarCount=0, workshopCount=0, seminarCount=0;
        	List<Training_Session__c> l1 = [SELECT ID, Name, RecordType.Name FROM Training_Session__c];
	        for(Training_Session__c tss : l1){
        		if(TypesOfRecord.valueOf(tss.RecordType.Name) == TypesOfRecord.Webinar)
            	{
            	    webinarCount++;
            	}
            
            	if(TypesOfRecord.valueOf(tss.RecordType.Name) == TypesOfRecord.Workshop)
            	{
            	    workshopCount++;
            	}
            
            	if(TypesOfRecord.valueOf(tss.RecordType.Name) == TypesOfRecord.Seminar)
            	{
            	    seminarCount++;
            	}
        	}
        	System.debug('Webinar Count = ' + webinarCount);
       		System.debug('Workshop Count = ' + workshopCount);
        	System.debug('Seminar Count = ' + seminarCount); 
        
        }catch(Exception e){
            System.debug('Update Failure ' + e.getMessage());
        }
    }
    /* 
        Purpose : Method that safely navigates through the relationships of a Training_Session__c record to fetch related Attendee__c records.
        Created By : Mayank Mathur(mayank.mathur@fexle.com)
        Created Date : 27/11/2024
    */
    public static void safeNavigationDemo()
    {
		List<Training_Session__c> l1 = [SELECT Id,Name, (SELECT Id,Name,Session_Name__c,Email__c FROM Attendees__r) FROM Training_Session__c Limit 1];
        System.debug(l1); 
        for(Training_Session__c tss : l1)
        {
            System.debug('Name = ' + tss?.Name);
            for(Attendee__c att : tss.Attendees__r)
            {    System.debug('Name = ' + att?.Name);
                 System.debug('Session = ' + att?.Session_Name__c);
                 System.debug('Email = ' + att?.Email__c);
            }
        }	    
    }
    /* 
        Purpose : Create custom labels for session types and use them in class methods to generate messages.
        Created By : Mayank Mathur(mayank.mathur@fexle.com)
        Created Date : 27/11/2024
    */
    public static void customLabelDemo()
    {
    	List<Training_Session__c> tsList = [SELECT Name,Session_Date__c,Webinar_Link__c,Location__c,RecordType.Name FROM Training_Session__c];
        
        for(Training_Session__c tss : tsList)
        {
            if(tss.RecordType.Name == 'Webinar')
            {
            	System.debug('Session Name : ' + tss.RecordType.Name + '  =>  Session Link : ' + tss.Webinar_Link__c + '  =>  Description : ' + Label.Label_for_Webinar);    
            }
            if(tss.RecordType.Name == 'Workshop')
            {
            	System.debug('Session Name : ' + tss.RecordType.Name + '  =>  Session Location : ' + tss.Location__c + '  =>  Description : ' + Label.Label_for_Workshop);    
            }
            if(tss.RecordType.Name == 'Seminar')
            {
            	System.debug('Session Name : ' + tss.RecordType.Name + '  =>  Session Date : ' + tss.Session_Date__c + '  =>  Description : ' + Label.Label_for_Seminar);    
            }
        }
    }
    /* 
        Purpose : complex SOQL queries to fetch training sessions based on specific criteria such as date, type, and attendee count.
        Created By : Mayank Mathur(mayank.mathur@fexle.com)
        Created Date : 02/12/2024
    */
    public static void complexSOQL(){

        System.debug('@@@@@@ Task 1 =================');        
        List<Training_Session__c> tsList1 = [SELECT Name FROM Training_Session__c WHERE Session_Date__c = 2025-11-13];
        for(Training_Session__c tss1 : tsList1)
            System.debug(tss1);
        
        System.debug('@@@@@@ Task 2 =================');
        List<Training_Session__c> tsList2 = [SELECT Id,Name FROM Training_Session__c WHERE RecordType.Name = 'Workshop'];
        for(Training_Session__c tss2 : tsList2)
        
            System.debug(tss2);
       	
        System.debug('@@@@@@ Task 3 =================');
        List<Training_Session__c> tsList3 = [SELECT Id,Name,TotalAttendee__c FROM Training_Session__c WHERE TotalAttendee__c > 0];
        for(Training_Session__c tss3 : tsList3)
            System.debug(tss3);        
    }
    
    /* 
        Purpose : To insert record in Training_Session__c Object using Database Class
        Created By : Mayank Mathur(mayank.mathur@fexle.com)
        Created Date : 02/11/2024
    */
    public static void insertFromDatabase() {
        
        List<Training_Session__c> listToAdd = new List<Training_Session__c>();
        //Loop to insert records
        for(Integer i=1; i<=10; i++)
        {
            Training_Session__c tssobj = new Training_Session__c();
            tssobj.Name = 'Subhash '+i;
            
            if(Math.mod(i,2)==0)
            	tssobj.Session_Date__c = Date.today().addDays(i*5);
            else
                tssobj.Session_Date__c = Date.today().addDays(-i*5);
            
            listToAdd.add(tssobj);
        }	
        
        Database.SaveResult[] insertedList = Database.insert(listToAdd, false);

        //Loop to show success & error logs
        for(Database.SaveResult sr : insertedList)
        {
			if(sr.isSuccess())
            {
				System.debug('Successfully inserted sessions with Record ID: '+sr.getId());
			}
            else
            {
                for(Database.Error err : sr.getErrors())
                {
					System.debug(err.getStatusCode() + ' : '+ err.getMessage());
                    for(String s : err.getFields())
                    {
                        System.debug('Field Names => ' + s);
                    }
				}
			}
    	}
    }
    
    /* 
        Purpose : To update record in Training_Session__c Object using Database Class
        Created By : Mayank Mathur(mayank.mathur@fexle.com)
        Created Date : 02/11/2024
    */
    public static void updateFromDatabase(){
        List<Training_Session__c> obj = [SELECT Id,Name,Session_Date__c FROM Training_Session__c WHERE Session_Date__c = null OR Session_Date__c < TODAY];

        //Loop to update records 
        for(Training_Session__c newobj : obj)
        {
            Integer i = 1;
			newobj.Session_Date__c = Date.today().addDays(i*2);
            i+=10;
            obj.add(newobj);
        }
        
        Database.SaveResult[] updatedList = Database.update(obj,false);

        //Loop to show success & error logs
        for(Database.SaveResult dsr : updatedList)
        {
			if(dsr.isSuccess())
            {	
            	System.debug('Successfully updated records with ID' + dsr.getID());
            }
            else
            {
                for(Database.Error de : dsr.getErrors())
                {
					System.debug(de.getStatusCode() + ' : '+ de.getMessage());
                    for(String s : de.getFields())
                    {
                        System.debug('Field Names => ' + s);
                    }
                }
            }
        }
    }
    
    /* 
        Purpose : To delete record from Training_Session__c Object using Database Class
        Created By : Mayank Mathur(mayank.mathur@fexle.com)
        Created Date : 02/11/2024
    */
    public static void deleteFromDatabase(){
        List<Training_Session__c> obj = [SELECT Id FROM Training_Session__c WHERE Session_Date__c = null OR Session_Date__c < TODAY];
        Database.DeleteResult[] deletedList = Database.delete(obj,false);

        //Loop to show success & error logs
        for(Database.DeleteResult ds : deletedList)
        {
            if(ds.isSuccess())
            {
                System.debug('Deleted Records : ' + ds.getID());
            }
            else
            {
                for(Database.Error de : ds.getErrors())
                {
                    System.debug('ErrorCode : ' + de.getStatusCode() + ' , Error Message = ' + de.getMessage());
                    for(String s : de.getFields())
                    {
                        System.debug('Error in Fields => ' + s);
                    }
                }
            }
        }
    }
    
    /* 
        Purpose : To upsert record in Training_Session__c Object using Database Class
        Created By : Mayank Mathur(mayank.mathur@fexle.com)
        Created Date : 02/11/2024
    */
    public static void upsertFromDatabase(){
        List<Training_Session__c> listToUpsert = [SELECT Id FROM Training_Session__c WHERE Location__c = 'Conference Hall'];
        //Loop to update record in the list
        for(Training_Session__c newobj : listToUpsert)
        {
            newobj.Location__c = 'Office';
        }
        //Loop to insert record in the list
        for(Integer i=1; i<=5; i++)
        {
            Training_Session__c tss = new Training_Session__c();
            tss.Name = 'Person '+ i;
            tss.Session_Date__c = Date.today().addDays(i*5);
            listToUpsert.add(tss);
        }
        
        Database.UpsertResult[] upsertedList = Database.upsert(listToUpsert, false);
        //Loop to show success & error logs
        for(Database.UpsertResult ur : upsertedList)
        {
            if(ur.isSuccess())
            {
                System.debug('Deleted Records : ' + ur.getID());
            }
            else
            {
                for(Database.Error der : ur.getErrors())
                {
                    System.debug('ErrorCode : ' + der.getStatusCode() + ' , Error Message = ' + der.getMessage());
                    for(String s : der.getFields())
                    {
                        System.debug('Error in Fields => ' + s);
                    }
                }
            }
        }
    }
}