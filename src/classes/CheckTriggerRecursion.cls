//This class checks for the recursion of the trigger events.
public with sharing class CheckTriggerRecursion {
    
    public static boolean flag=true;
    
    //This method sets recursion flag once the trigger has been initiated for one transaction.
    public static boolean checkTriggerExecutionFlag(){
    
        if(flag)
        {
            flag=false;
            return true;
        }
        else
        {
            return flag;
        }
    }
}