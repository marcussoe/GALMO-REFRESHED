public without sharing class LeadHelper {
    public static void statusValidate(List<Lead> newLeads, Map<Id, Lead> oldLeads){
        Set<String> statusLeadSet = new Set<String>();
        for (Lead lead : newLeads) {
            Lead oldLead = oldLeads.get(lead.Id);
            if (lead.Status != oldLead.Status) {
                statusLeadSet.add(lead.Status);
            }
        }
        if (!statusLeadSet.isEmpty()) {
            Map<String, BusinessSettings__c> configMap = new Map<String, BusinessSettings__c>();
            configMap.putAll([
                SELECT Id, Step__c
                FROM BusinessSettings__c
                WHERE Step__c IN :statusLeadSet
            ]);
            for (Lead lead : newLeads) {
                Lead oldLead = oldLeads.get(lead.Id);
                if (lead.Status != oldLead.Status && !configMap.containsKey(lead.Status)) {
                    lead.ConfiguracaoDeSLA__c = null;
                    lead.DataHoraVencimento__c = null;
                }   
            }
        }
        
    }



    





    public static void verifyContactingStatus(Map<String, List<Lead>> statusToLeadsMap){
        List<Lead> openLeads = statusToLeadsMap.get('Open');
        if (openLeads != null) {
            validateContactTasks(openLeads, false);
        }
        List<Lead> completedLeads = statusToLeadsMap.get('Completed');
        if (completedLeads != null) {
            validateContactTasks(completedLeads, true);
        }
    }


    
    private static void validateContactTasks(List<Lead> leads, Boolean isCompleted) {
        Set<String> allowedSubjects = new Set<String>{'Chamada', 'Email', 'WhatsApp'};
        Map<Id, List<Task>> taskMap = getContactTasksMap(new Map<Id, Lead>(leads).keySet(), isCompleted);
        for (Lead lead : leads) {
            if (!taskMap.containsKey(lead.Id)) {
                String taskType = isCompleted ? 'concluída' : 'não concluída';
                lead.addError('É necessário ter pelo menos uma tarefa ' + taskType + ' do tipo Chamada, Email ou WhatsApp associada a este lead.');
            }
        }
    }


    
    private static Map<Id, List<Task>> getContactTasksMap(Set<Id> leadsId, Boolean isCompleted){
        List<Task> tasks = TaskDA.getContactTasksByWhoId(leadsId, isCompleted);
        Map<Id, List<Task>> taskMap = new Map<Id, List<Task>>();
        for (Task task : tasks) {
            if (!taskMap.containsKey(task.WhoId)) {
                taskMap.put(task.WhoId, new List<Task>());
            }
            taskMap.get(task.WhoId).add(task);
        }
        return taskMap;
    }

    public static void verifyLeadControlSLA(List<Lead> leadList){
        Set<String> statusSet = new Set<String>();
        for (Lead lead : leadList) {
            statusSet.add(lead.Status);
        }
        Map<String, BusinessSettings__c> settingsMap = new Map<String, BusinessSettings__c>();
        RecordType slaRecordType = [SELECT Id FROM RecordType WHERE DeveloperName = 'Controle_SLA' LIMIT 1];
        for(BusinessSettings__c setting : [SELECT Id, SlaTime__c, Step__c FROM BusinessSettings__c WHERE RecordTypeId = :slaRecordType.Id AND Step__c IN :statusSet]) {
            settingsMap.put(setting.Step__c, setting);
        }
        for (Lead lead : leadList) {
            if (settingsMap.containsKey(lead.Status)) {
                BusinessSettings__c setting = settingsMap.get(lead.Status);
                lead.DataHoraVencimento__c = Datetime.now().addMinutes(Integer.valueOf(setting.SlaTime__c));
                lead.ConfiguracaoDeSLA__c = setting.Id;
            }
        }
    }
   
    

    public static void additionalValidations(List<Lead> newLeads, Map<Id, Lead> oldLeads) {
        for (Lead lead : newLeads) {
            Lead oldLead = oldLeads.get(lead.Id);
    
            if (lead.Tipo_de_Negociacao__c == 'Locador/Proprietário') {
                continue;
            }
    
            if (oldLead.Status.equalsIgnoreCase('Tentativa de contato') && lead.Status.equalsIgnoreCase('Contato Realizado')) {
                if (!isTaskCreatedAndOpenForAttemptToContact(lead.Id)) { 
                    lead.addError(Label.TentativaContato_LEAD);
                }
            } else if (oldLead.Status.equalsIgnoreCase('Agendamento de Visita') && lead.Status.equalsIgnoreCase('Qualificação') && 
                       !hasCompletedTaskForLead(lead.Id)) { 
                lead.addError(Label.ContatoRealizado_LEAD);
            } else if ((oldLead.Status.equals('Descartado') || oldLead.Status.equals('Perdido/Não Trabalhado') || 
                        oldLead.Status.equals('Novo') || oldLead.Status.equals('Nutrindo')) && lead.Status.equals('Contato Realizado')) {
                lead.addError(Label.Fases_LEAD);
            } else if ((oldLead.Status.equalsIgnoreCase('Descartado') || oldLead.Status.equalsIgnoreCase('Perdido/Não Trabalhado') || 
                        oldLead.Status.equalsIgnoreCase('Novo') || oldLead.Status.equalsIgnoreCase('Nutrindo') || 
                        oldLead.Status.equalsIgnoreCase('Tentativa de contato')) && lead.Status.equalsIgnoreCase('Agendamento de Visita')) {
                lead.addError(Label.TentativaContato_LEAD);
            } else if ((lead.Status.equalsIgnoreCase('Qualificação') || oldLead.Status.equalsIgnoreCase('Conversão'))) {
                if (!lead.LeadNaoQuisVisitar__c && isEventCreatedForVisits(lead.Id)) {
                    lead.addError(Label.Agendamento_LEAD);
                }
            } else if ((new Set<String>{'Descartado', 'Perdido/Não Trabalhado', 'Novo', 'Nutrindo', 
                        'Tentativa de contato', 'Contato Realizado', 'Agendamento de Visita'}).contains(oldLead.Status) && 
                        lead.Status == 'Conversão') {
                lead.addError(Label.Conversao_LEAD);
            }
            if (lead.LeadNaoQuisVisitar__c) {
                Boolean canAdvance = checkPreviousPhaseValidations(oldLead.Status, lead.Status, lead.Id);
                if (!canAdvance) {
                    lead.addError(Label.TentativaContato_LEAD);
                }
            }
        }
    }
    

        private static Boolean checkPreviousPhaseValidations(String oldStatus, String newStatus, Id leadId) {
        if (oldStatus.equalsIgnoreCase('Tentativa de contato') && newStatus.equalsIgnoreCase('Contato Realizado')) {
            return isTaskCreatedAndOpenForAttemptToContact(leadId);
        }
    
        if (oldStatus.equalsIgnoreCase('Agendamento de Visita') && newStatus.equalsIgnoreCase('Qualificação')) {
            return hasCompletedTaskForLead(leadId);
        }
  
        if (newStatus.equalsIgnoreCase('Qualificação')) {
            return !isEventCreatedForVisits(leadId);
        }
        return true;
    }
    
    

    public static void validateTaskCreation(List<Task> newTasks) {
        Set<Id> leadIds = new Set<Id>();
        for (Task task : newTasks) {
            if (task.WhoId != null && task.WhoId.getSObjectType() == Lead.SObjectType) {
                leadIds.add(task.WhoId);
            }
        }
        if (!leadIds.isEmpty()) {
            Map<Id, Lead> leads = new Map<Id, Lead>([SELECT Id, Status FROM Lead WHERE Id IN :leadIds]);
            for (Task task : newTasks) {
                if (task.WhoId != null && leads.containsKey(task.WhoId)) {
                    Lead lead = leads.get(task.WhoId);
                    if (isTaskCreationNotAllowedForTentativaContato(lead.Status, task.Subject)) {
                         if(task.Subject == 'Reiteração'){
                            continue;
                        }
                        
                        task.addError('Só é permitido criar uma tarefa  quando o lead está nas fases Tentativa de Contato ou Contato Realizado.');
                    }
                }
            }
        }
    }

    
    private static Boolean isTaskCreationNotAllowedForTentativaContato(String leadStatus, String taskSubject) {
        Set<String> disallowedStatuses = new Set<String>{'Descartado', 'Perdido/Não Trabalhado', 'Novo', 'Nutrindo','Agendamento de Visita','Qualificação'};
        if (disallowedStatuses.contains(leadStatus)) { return true; }
        Set<String> allowedTaskTypes = new Set<String>{'Chamada', 'Email', 'Whatsapp','Enviar cotação','Visita','Outros'};return !allowedTaskTypes.contains(taskSubject); 
    }




    public static void updateLeadStatusOnTaskCompletion(List<SObject> newTasks, Map<Id, SObject> oldTasks) {
        Set<Id> leadIdsToUpdate = new Set<Id>();
        List<Task> newTaskList = (List<Task>)newTasks;
        Map<Id, Task> oldTaskMap = (Map<Id, Task>)oldTasks;
        for (Task newTask : newTaskList) {
            Task oldTask = oldTaskMap.get(newTask.Id);
            
            
            if (newTask.Status == 'Completed' && (oldTask == null || oldTask.Status != 'Completed') && 
                (newTask.Subject == 'Email' || newTask.Subject == 'Whatsapp' || newTask.Subject == 'Chamada')) {
                leadIdsToUpdate.add(newTask.WhoId);
            }
        }
        if (!leadIdsToUpdate.isEmpty()) {
            List<Lead> leadsToUpdate = LeadDA.getLeadsByIds(leadIdsToUpdate);
            for (Lead lead : leadsToUpdate) {
                if (lead.Status == 'Tentativa de Contato') {
                    lead.Status = 'Contato Realizado';
                }
            }
            update leadsToUpdate;
        }
    }
    
 
    
    private static Boolean isTaskCreatedAndOpenForAttemptToContact(Id leadId) {
        List<Task> tasks = TaskDA.getContactTasksByWhoId(new Set<Id>{leadId}, 'Completed');   return !tasks.isEmpty();
    }



    public static Boolean isEventCreatedForVisits(Id leadId) {
        List<Event> events = EventDA.getAllEventByLead(new Set<Id>{leadId});    
        return events.isEmpty(); 
    }


    private static Boolean hasCompletedTaskForLead(Id leadId) { 
        List<Task> tasks = TaskDA.getContactTasksByWhoId(new Set<Id>{leadId}, 'Completed');return !tasks.isEmpty();
    }

    
    public static void setInterestedEnterprise (List<Lead> newLeads) {
        Map<String, List<Lead>> mapLeadStatus = new Map<String, List<Lead>>();
        for (Lead newLead : newLeads) {
            if(newLead.EmpreendimentoInteresseLead__c == null){
                if(mapLeadStatus.containskey(newLead.EmpreendimentoInteresseWeb__c)){
                    mapLeadStatus.get(newLead.EmpreendimentoInteresseWeb__c).add(newLead);
                }else{
                    mapLeadStatus.put(newLead.EmpreendimentoInteresseWeb__c, new List<Lead>{newLead});
                }
            }
        }
        for(Enterprise__c empreendimento : [Select Id, Name from Enterprise__c where name =: mapLeadStatus.keyset()]){
            for(Lead ld : mapLeadStatus.get(empreendimento.name)){
                ld.EmpreendimentoInteresseLead__c = empreendimento.Id;
            }
        }
    }

    public static void setFirstDevelopment(List<Lead> newLeads) {
        for (Lead lead : newLeads) {
             lead.PrimeiroEmpreendimento__c = lead.EmpreendimentoInteresseLead__c; 
        }
    }
    

    public static void setOriginalMedia(List<Lead> newLeads) {
        for (Lead lead : newLeads) {
            lead.UTMOriginalMedia__c = lead.UTMOriginalMedia__c; 
        }
    }

    
    public static void handleLeadReiteration(Lead existingLead, Map<String, Object> params) {
        if(params.containsKey('campaignName')){
            String campaignName = (String)params.get('campaignName');
            Campaign campaign = LeadDA.findCampaignByName(campaignName);
            if(campaign != null){
                CampaignMember campaignMember = new CampaignMember(
                    CampaignId = campaign.Id,
                    LeadId = existingLead.Id
                );
                insert campaignMember;
            }
        }
        updateLeadFields(existingLead, params);
        createTaskForReiteration(existingLead);
    }
    
    private static void updateLeadFields(Lead lead, Map<String, Object> params) {
        lead.QuantidadeReiteracoes__c = lead.QuantidadeReiteracoes__c != null ? lead.QuantidadeReiteracoes__c + 1 : 1;
    
        Boolean isModified = false;
        for (String fieldName : params.keySet()) {
            if (params.containsKey(fieldName) && lead.get(fieldName) != params.get(fieldName)) {
                lead.put(fieldName, params.get(fieldName));
                isModified = true;
            }
        }
    
        if (isModified) {
            lead.ltima_Reitera_o__c = Date.today();
            update lead;
        }
    }
    
    public static void scheduleLeadChange(List<Lead> leadList, Map<Id, Lead> oldLeads) {
        for (Lead ld : leadList) {
         
            if (oldLeads == null || ld.Status != oldLeads.get(ld.Id).Status) {
                
                if (ld.DataHoraVencimento__c != null) {
                   
                    String sch = ld.DataHoraVencimento__c.second() + ' ' + ld.DataHoraVencimento__c.minute() + ' ' + ld.DataHoraVencimento__c.hour() + ' ' + ld.DataHoraVencimento__c.day() + ' ' + ld.DataHoraVencimento__c.month() + ' ? ' + ld.DataHoraVencimento__c.year();
                    System.debug('Agendando job com expressão cron: ' + sch);
    
                  
                    System.schedule(ld.Name + ' ' + DateTime.now().getTime(), sch, new ApplyVersion(ld.Id));
                }
            }
        }
    }
    

    
    private static void createTaskForReiteration(Lead lead) {
        if (lead.Status != 'Tentativa de Contato' && lead.Status != 'Contato Realizado') {
            return; 
        }
        
      
        List<Task> openTasks = TaskDA.getOpenTasksForLead(lead.Id);
    
      
        String taskStatus = openTasks.isEmpty() ? 'Open' : 'Completed';
        
       
        Task newTask = new Task(
            WhoId = lead.Id,
            Subject = 'Reiteração',
            Status = taskStatus,
            ActivityDate = Date.today().addDays(1),
            Description = 'Reiteração do Lead. Nome: ' + lead.LastName 
            + ', Telefone: ' + lead.MobilePhone 
            + ', Email: ' + lead.Email 
            + ', Empreendimento de Interesse: ' + lead.EmpreendimentoInteresseLead__c 
            + ', Origem do Lead: ' + lead.LeadSource 
            + ', Data e horário da interação: ' + lead.ltima_Reitera_o__c   
        );
    
       
        insert newTask;
    }

    public static void validacaoComecarLeadComoNovo(List<Lead> leadList) {
        for (Lead lead : leadList) {
            if (lead.Tipo_de_Negociacao__c == 'Locador/Proprietário') {
                lead.Status = 'Conversão';
            } else if (lead.Status != 'Novo') {
                lead.addError('O status do lead deve ser Novo para ser iniciado como novo.');
            }
        }
    }
    
        public static void convertLead(List<Lead> leadList) {
            List<Lead> leadsToUpdate = new List<Lead>();
            
            for (Lead lead : leadList) {
                if (lead.Tipo_de_Negociacao__c == 'Locador/Proprietário') {
                    lead.Status = 'Conversão';
                    leadsToUpdate.add(lead);
                }
            }
            
            if (!leadsToUpdate.isEmpty()) {
                update leadsToUpdate;
            }
        }
    
    
}