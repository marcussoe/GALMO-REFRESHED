trigger ValidateUniqueContactRoleTrigger on OpportunityContactRole (before insert, before update) {
    // Mapeia as oportunidades e contatos que estão sendo processados
    Map<Id, Set<Id>> opportunityContactMap = new Map<Id, Set<Id>>();

    // Carrega os registros existentes de OpportunityContactRole para as oportunidades afetadas
    Set<Id> opportunityIds = new Set<Id>();
    for (OpportunityContactRole ocr : Trigger.new) {
        opportunityIds.add(ocr.OpportunityId);
    }

    // Consulta os OpportunityContactRole existentes para as oportunidades afetadas
    Map<Id, List<OpportunityContactRole>> existingRolesMap = new Map<Id, List<OpportunityContactRole>>();
    for (OpportunityContactRole ocr : [SELECT OpportunityId, ContactId, Role FROM OpportunityContactRole WHERE OpportunityId IN :opportunityIds]) {
        if (!existingRolesMap.containsKey(ocr.OpportunityId)) {
            existingRolesMap.put(ocr.OpportunityId, new List<OpportunityContactRole>());
        }
        existingRolesMap.get(ocr.OpportunityId).add(ocr);
    }

    // Verifica se há duplicações no Trigger.new
    for (OpportunityContactRole ocr : Trigger.new) {
        if (!opportunityContactMap.containsKey(ocr.OpportunityId)) {
            opportunityContactMap.put(ocr.OpportunityId, new Set<Id>());
        }
        Set<Id> contactSet = opportunityContactMap.get(ocr.OpportunityId);
        
        if (contactSet.contains(ocr.ContactId)) {
            ocr.addError('Não é permitido adicionar o mesmo contato com papéis diferentes na mesma oportunidade.');
        } else {
            // Verifica contra os registros existentes
            if (existingRolesMap.containsKey(ocr.OpportunityId)) {
                for (OpportunityContactRole existingOcr : existingRolesMap.get(ocr.OpportunityId)) {
                    if (existingOcr.ContactId == ocr.ContactId && existingOcr.Id != ocr.Id) {
                        ocr.addError('Não é permitido adicionar o mesmo contato com papéis diferentes na mesma oportunidade.');
                        break;
                    }
                }
            }
            contactSet.add(ocr.ContactId);
        }
    }
}