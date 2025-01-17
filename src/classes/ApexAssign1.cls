/* 
    Description : To implement Assignment 1 of Apex Basics (List, Map, Sets)

    Created By : Mayank Mathur(mayank.mathur@fexle.com)

    Created Date : 26/11/2024

    Revision Log : Version 1.0
*/
public with sharing class ApexAssign1 {

    /* 
        Purpose : To create a map with Department as 'key' and Employee name as 'value'
        Created By : Mayank Mathur(mayank.mathur@fexle.com)
        Created Date : 26/11/2024
    */
    public void listImplement() {

        System.debug('=================================== MAP METHOD ==========================================');

        List<String> sales = new List<String>{'Katrina' , 'Kiara' , 'Alia'};    //List of Sales Team Employees
        List<String> hr = new List<String>{'Gopi' , 'Uday' , 'Sid'};            //List of HR Team Employees
        List<String> tech = new List<String>{'Ravi' , 'Dev' , 'Raj'};           //List of Tech Team Employees
    
        Map<String, List<String>> myTeam = new Map<String, List<String>>();     //Empty Map to store Department as Key & Employee Names as List
    
        myTeam.put('Sales' , sales);                                            //Putting Sales Team record
        myTeam.put('HR' , hr);                                                  //Putting HR Team record
        myTeam.put('Tech' , tech);                                              //Putting Tech Team record
    
        System.debug('Department Employees List ' + myTeam);
    }
    
    /* 
        Purpose : To perform Union, Intersection & Difference of Set
        Created By : Mayank Mathur(mayank.mathur@fexle.com)
        Created Date : 26/11/2024
    */
    public void setImplement() {

        System.debug('=================================== SET METHOD ==========================================');

        Set<String> set1 = new Set<String>{'Amit', 'Varun', 'Sid', 'Kiara', 'Dev'};         //String Set 1 of Names
        Set<String> set2 = new Set<String>{'Akshay', 'Salman', 'Alia', 'Amit', 'Dev'};      //String Set 2 of Names

        Set<String> unionSet = new Set<String>();                                           //Empty Set to create Union
        unionSet.addAll(set1);                                                              //Adding Set 1 elements
        unionSet.addAll(set2);                                                              //Adding Set 1 elements

        Set<String> intersectionSet = new Set<String>(set1);                                //Empty Set to create Intersection
        intersectionSet.retainAll(set2);                                                    //Intersection of Set 1 & Set 2

        Set<String> diffSet1 = new Set<String>(set1);                                       //Empty Set to create Difference A-B
        diffSet1.removeAll(set2);                                                           //Difference Set = Set 1 - Set 2

        Set<String> diffSet2 = new Set<String>(set2);                                       //Empty Set to create Difference B-A
        diffSet2.removeAll(set1);                                                           //Difference Set = Set 2 - Set 1
        
        System.debug('Union: ' + unionSet);
        System.debug('Intersection: ' + intersectionSet);
        System.debug('Difference (A - B): ' + diffSet1);
        System.debug('Difference (B - A): ' + diffSet2);
    }
    
    /* 
        Purpose : To create a list of 10 integers and print it in ascending order
        Created By : Mayank Mathur(mayank.mathur@fexle.com)
        Created Date : 26/11/2024
    */
    public void mapImplement() {
        
        System.debug('=================================== LIST METHOD ==========================================');
        
        List<integer> l1 = new List<integer>();                                 //Empty List to store integers
        for(Integer i = 1; i<=10;i++)                                           //Loop which will run 10 times
        {
            l1.add(Math.round(Math.random()*100));                              //Generate 1 random numbers and add in list
        }
        System.debug('Original List = ' + l1);                                  
        l1.sort();                                                              //Sort List in Ascending Order
        System.debug('Sorted List = ' + l1);
    }
}