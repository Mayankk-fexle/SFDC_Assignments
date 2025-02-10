global class ScheduleArchiveOperation implements Schedulable
{
    global void execute(SchedulableContext sc)
    {
		ArchiveOperation obj = new ArchiveOperation();
		Id batchId = Database.executeBatch(obj);        
    }
}

/*
String cronExp = '0 0 0 1 * ? *';
ScheduleArchiveOperation scheduleJob = new ScheduleArchiveOperation();
System.schedule('Monthly Archive Operation', cronExp, scheduleJob);
*/