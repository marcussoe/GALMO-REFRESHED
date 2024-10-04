public class EventHelper {       
    public static void validateEventDate(List<Event> events){
        Set<Id> whoIds = new Set<Id>();
    
        for (Event iEvent : events) {
            whoIds.add(iEvent.WhoId);
        }
        
        Map<Id, Lead> leadMap = new Map<Id, Lead>([SELECT Id, ConfiguracaoDeSLA__r.SlaTime__c FROM Lead WHERE Id IN :whoIds]);
        
        for (Event iEvent : events) {
            if (iEvent.ActivityDate > Datetime.now()) {
                Lead leadRecord = leadMap.get(iEvent.WhoId);
                if (leadRecord != null && leadRecord.ConfiguracaoDeSLA__r != null && leadRecord.ConfiguracaoDeSLA__r.SlaTime__c != null) {
                    leadRecord.DataHoraVencimento__c = DateTime.newInstance(iEvent.ActivityDate.year(), iEvent.ActivityDate.month(), iEvent.ActivityDate.day()).addMinutes(Integer.valueOf(leadRecord.ConfiguracaoDeSLA__r.SlaTime__c));
                }
            }
          }
    }
    
    
    public static void validateLeadStatus(List<Event> eventList) {
        Map<Id, Lead> leadsMappedByEventId = getScheduledLeadsMap(eventList);

        for(Event event: eventList){
            if(event.Subject == 'Visita'){
                Lead ld = leadsMappedByEventId.get(event.Id);
                
                if(ld != null){
                    if(ld.Status == 'Agendamento de Visita'){
                        event.EmpreendimentoInteresseAtividade__c = ld.EmpreendimentoInteresseLead__c;
                    }else{
                        event.addError('O status do lead precisa ser Agendamento de Visita');
                    }
                }
            }                
        }
       
    }

    public static void validateEventStatus(List<Event> events) {
        Set<Id> idLeads = new Set<Id>();
    
        List<Event> eventosVisita = new List<Event>();
    
        for (Event iEvent : events) {       
            if (iEvent.Subject == 'Visita') {
                idLeads.add(iEvent.WhoId);
                eventosVisita.add(iEvent);
            }
        }
        Map<Id, Lead> mapLeads = getScheduledLeadsMap(eventosVisita);

        if (!idLeads.isEmpty()) {
            List<Lead> leads = new List<Lead>();

            for (Event event : eventosVisita) {
                Lead lead = mapLeads.get(event.Id);
                if (lead != null) {
                    if (lead.Status == 'Agendamento de Visita' && event.StatusCompromisso__c == 'Realizada com Sucesso') {
                        lead.Status = 'Qualificação';
                        leads.add(lead);
                    } else if (lead.Status == 'Agendamento de Visita' && event.StatusCompromisso__c == 'Não realizada') { 
                        if (String.isBlank(event.MotivoVisitaNaoRealizada__c)) {
                            event.addError('Informar o motivo da visita não realizada. Escolha uma opção na lista, por favor.');
                        } else {
                            lead.Status = 'Contato Realizado';
                            leads.add(lead);
                        }
                    }
                }
            }
            if(!leads.isEmpty()){
                update leads;
            }
        }
    }

    private static Map<Id, Lead> getScheduledLeadsMap(List<Event> events){
        List<Lead> scheduledLeads = LeadDA.getLeadScheduledById(
            new Set<String>{'Id', 'Status', 'EmpreendimentoInteresseLead__c' },
            ObjectHelper.getLookUpId(events, 'WhoId')
        );

        Map<Id, Lead> scheduledLeadsMap = new Map<Id, Lead>(scheduledLeads);
        Map<Id, Lead> leadsMappedByEventId = new Map<Id, Lead>();
        
        for(Event iEvent : events){
            if(iEvent.WhoId != null && scheduledLeadsMap.containsKey(iEvent.WhoId)) {
                leadsMappedByEventId.put(iEvent.Id, scheduledLeadsMap.get(iEvent.WhoId));
            }
        }
        
        return leadsMappedByEventId;
    }

  
    
       
}