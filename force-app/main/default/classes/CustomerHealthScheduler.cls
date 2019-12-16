/**
* @author Pratibh Prakash
* @date 25-May-2017
* @description Batch Class processing Jira health scores
* @last modified by 
*/
global class CustomerHealthScheduler Implements Schedulable{
	global void execute(SchedulableContext sc){
		CustomerHealthScoreUtility.calculateJiraHealthScore(null);
	}
}