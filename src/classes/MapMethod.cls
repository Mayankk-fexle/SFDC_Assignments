public with sharing class MapMethod 
{
    public MapMethod() 
    {
        List<String> sales = new List<String>{'Katrina' , 'Kiara' , 'Alia'};
        List<String> hr = new List<String>{'Gopi' , 'Uday' , 'Sid'};
        List<String> tech = new List<String>{'Ravi' , 'Dev' , 'Raj'};
    
        Map<String, List<String>> myTeam = new Map<String, List<String>>();
    
        myTeam.put('Sales' , sales);
        myTeam.put('HR' , hr);
        myTeam.put('Tech' , tech);
    
        System.debug('Department Employees List ' + myTeam);
    }
}