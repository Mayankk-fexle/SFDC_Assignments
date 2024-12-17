/* 
    Description : After Trigger on Attendee to Count no. of Training Sessions of Attendees on Contact

    Created By : Mayank Mathur(mayank.mathur@fexle.com)

    Created Date : 14/12/2024

    Revision Log : Version 1.0
*/
trigger AttendeeTrigger on Attendee__c (before insert, before update, before delete, 
                                        after insert, after update, after delete, after undelete) 
{
    new AttendeeTriggerHandler().run();
}