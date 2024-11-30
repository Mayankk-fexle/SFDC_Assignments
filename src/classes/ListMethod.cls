public with sharing class ListMethod 
{
    public ListMethod() 
    {
        List<integer> l2 = new List<integer>();
        for(Integer i = 1; i<=10;i++)
        {
            l2.add(Math.round(Math.random()*100));
        }
        System.debug('Original List = ' + l2);
        l2.sort();
        System.debug('Sorted List = ' + l2);
    }
}