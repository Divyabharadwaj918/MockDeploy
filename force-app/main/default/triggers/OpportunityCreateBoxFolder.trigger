trigger OpportunityCreateBoxFolder on Opportunity (after insert) {
    if (!test.isRunningTest()) system.enqueueJob(new OpportunityCreateBoxFolder_Queue((Opportunity[]) trigger.new));
}