public with sharing class ApexAssign1 {
    public listImplement() {

        System.debug('=================================== MAP METHOD ==========================================');

        List<String> sales = new List<String>{'Katrina' , 'Kiara' , 'Alia'};
        List<String> hr = new List<String>{'Gopi' , 'Uday' , 'Sid'};
        List<String> tech = new List<String>{'Ravi' , 'Dev' , 'Raj'};
    
        Map<String, List<String>> myTeam = new Map<String, List<String>>();
    
        myTeam.put('Sales' , sales);
        myTeam.put('HR' , hr);
        myTeam.put('Tech' , tech);
    
        System.debug('Department Employees List ' + myTeam);
    }
    
    public setImplement() {

        System.debug('=================================== SET METHOD ==========================================');

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

        System.debug('=================================== LIST METHOD ==========================================');
        
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