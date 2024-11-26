public with sharing class ApexAssign1 {
    public ApexAssign1() {

        System.debug('=================================== MAP METHOD ==========================================');

        List<String> sales = new List<String>{'Katrina' , 'Kiara' , 'Alia'};
        List<String> hr = new List<String>{'Gopi' , 'Uday' , 'Sid'};
        List<String> tech = new List<String>{'Ravi' , 'Dev' , 'Raj'};
    
        Map<String, List<String>> myTeam = new Map<String, List<String>>();
    
        myTeam.put('Sales' , sales);
        myTeam.put('HR' , hr);
        myTeam.put('Tech' , tech);
    
        System.debug('Department Employees List ' + myTeam);
        
        System.debug('=================================== SET METHOD ==========================================');

        Set<String> set1 = new Set<String>{'Amit', 'Varun', 'Sid', 'Kiara', 'Dev'};
        Set<String> set2 = new Set<String>{'Akshay', 'Salman', 'Alia', 'Amit', 'Dev'};

        Set<String> UnionSet = new Set<String>();
        UnionSet.addAll(set1);
        UnionSet.addAll(set2);

        Set<String> IntersectionSet = new Set<String>(set1);
        IntersectionSet.retainAll(set2);

        Set<String> DifferenceSet1 = new Set<String>(set1);
        DifferenceSet1.removeAll(set2);

        Set<String> DifferenceSet2 = new Set<String>(set2);
        DifferenceSet2.removeAll(set1);
        
        System.debug('Union: ' + UnionSet);
        System.debug('Intersection: ' + IntersectionSet);
        System.debug('Difference (A - B): ' + DifferenceSet1);
        System.debug('Difference (B - A): ' + DifferenceSet2);

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

ApexAssign1 obj = new ApexAssign1();