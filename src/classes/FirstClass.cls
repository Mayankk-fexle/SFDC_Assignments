public with sharing class FirstClass 
{    
    public FirstClass()
    {    
        Set<String> set1 = new Set<String>{'Amit', 'Varun', 'Sid', 'Kiara', 'Dev'};
        Set<String> set2 = new Set<String>{'Akshay', 'Salman', 'Alia', 'Amit', 'Dev'};

        Set<String> union_set = new Set<String>();
        union_set.addAll(set1);
        union_set.addAll(set2);

        Set<String> intersect_set = new Set<String>(set1);
        intersect_set.retainAll(set2);

        Set<String> diff_set1 = new Set<String>(set1);
        diff_set1.removeAll(set2);

        Set<String> diff_set2 = new Set<String>(set2);
        diff_set2.removeAll(set1);
        
        System.debug('Union: ' + union_set);
        System.debug('Intersection: ' + intersect_set);
        System.debug('Difference (A - B): ' + diff_set1);
        System.debug('Difference (B - A): ' + diff_set2);
    }
}

FirstClass obj = new FirstClass();