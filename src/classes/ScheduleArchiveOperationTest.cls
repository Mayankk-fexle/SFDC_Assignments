@isTest
public class ScheduleArchiveOperationTest 
{
    @isTest
    static void testScheduleArchiveOperation() 
    {
        // Define cron expression for scheduling
        String cronExp = '0 0 0 1 * ? *'; // Runs on the 1st day of every month

        // Schedule the job
        Test.startTest();
        String jobId = System.schedule('Monthly Archive Operation', cronExp, new ScheduleArchiveOperation());
        Test.stopTest();

        // Validate that the job is scheduled
        CronTrigger ct = [SELECT Id, CronExpression, State FROM CronTrigger WHERE Id = :jobId];
        Assert.isNotNull(ct, 'The scheduled job should exist.');
        System.assertEquals('WAITING', ct.State, 'The job should be in WAITING state.');
    }
}