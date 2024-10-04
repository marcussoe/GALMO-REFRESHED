public class TaskHelper {
    public static void validateTaskDate(List<Task> tasks){
        Set<Id> whoIds = new Set<Id>();
        for (Task iTask : tasks) {
            whoIds.add(iTask.WhoId);
        }
        Map<Id, Lead> leadMap = new Map<Id, Lead>([SELECT Id, ConfiguracaoDeSLA__r.SlaTime__c  FROM Lead WHERE Id IN :whoIds]);
        for (Task iTask : tasks) {
            if (iTask.ActivityDate > Date.today()) {
                Lead leadRecord = leadMap.get(iTask.WhoId);
                if (leadRecord != null && leadRecord.ConfiguracaoDeSLA__r != null) {
                    Integer tempoDeSLA = Integer.valueOf(leadRecord.ConfiguracaoDeSLA__r.SlaTime__c)/60/24;
                    System.debug(tempoDeSLA);
                    if (tempoDeSLA != null) {
                        iTask.ActivityDate = iTask.ActivityDate.addDays(tempoDeSLA);
                    }
                }
            }
        }
    }
}