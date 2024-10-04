public with sharing class TaskDA {
    public static List<Task> getContactTasksByWhoId(Set<Id> leadsId, Boolean completed) {
        String subjectCondition = '(Subject = \'Chamada\' OR Subject = \'Email\' OR Subject = \'WhatsApp\')';
        String statusCondition = completed ? 'Status = \'Completed\'' : 'Status != \'Completed\'';
        String query = 'SELECT Id, WhoId, Subject FROM Task WHERE WhoId IN :leadsId AND ' + statusCondition + ' AND ' + subjectCondition;
        return Database.query(query);
    }
    
    
  
    public static List<Task> getContactTasksByWhoId(Set<Id> leadsId, String status) {
        String subjectCondition = '(Subject = \'Chamada\' OR Subject = \'Email\' OR Subject = \'WhatsApp\')';
        String statusCondition = 'Status = \'' + status + '\'';
        String query = 'SELECT Id, WhoId, Subject FROM Task WHERE WhoId IN :leadsId AND ' + statusCondition + ' AND ' + subjectCondition;
        return Database.query(query);
    }


    
    public static List<Task> getOpenTasksForLead(Id leadId) {
        return [SELECT Id FROM Task WHERE WhoId = :leadId AND Status != 'Completed' LIMIT 1];
    }
}