/* 
    Description : Before Insert and Before Update Trigger on Contact to verify Email of new Contacts with Domain of their associated Accounts(if any)

    Created By : Mayank Mathur(mayank.mathur@fexle.com)

    Created Date : 04/12/2024

    Revision Log : Version 1.0
*/
trigger ContactTrigger on Contact (before insert, before update, before delete, after insert, after update, after delete, after undelete) 
{
    new ContactTriggerHandler().run();
}