public with sharing class SetMethod 
{
    public SetMethod() 
    {
        Set<String> set1 = new Set<String>{'Amit', 'Varun', 'Sid', 'Kiara', 'Dev'};
        Set<String> set2 = new Set<String>{'Akshay', 'Salman', 'Alia', 'Amit', 'Dev'};

        Set<String> unionSet = new Set<String>();
        unionSet.addAll(set1);
        unionSet.addAll(set2);

        Set<String> intersectionSet = new Set<String>(set1);
        intersectionSet.retainAll(set2);

        Set<String> diffSet1 = new Set<String>(set1);
        diffSet1.removeAll(set2);

        Set<String> diffSet2 = new Set<String>(set2);
        diffSet2.removeAll(set1);
        
        System.debug('Union: ' + unionSet);
        System.debug('Intersection: ' + intersectionSet);
        System.debug('Difference (A - B): ' + diffSet1);
        System.debug('Difference (B - A): ' + diffSet2);

    }
}