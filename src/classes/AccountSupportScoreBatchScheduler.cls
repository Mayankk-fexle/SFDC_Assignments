public class AccountSupportScoreBatchScheduler implements Schedulable
{
	public static void execute(SchedulableContext sc)
    {
        AccountSupportScoreBatch obj = new AccountSupportScoreBatch();
        Database.executeBatch(obj);
    }
}