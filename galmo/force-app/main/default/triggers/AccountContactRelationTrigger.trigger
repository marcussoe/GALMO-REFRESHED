trigger AccountContactRelationTrigger on AccountContactRelation (before insert, before update) {
    Map<Id, Integer> accountSpouseCount = new Map<Id, Integer>();

    // Conta o número de registros existentes por conta com relacionamento marcado como "Cônjuge/Companheiro"
    for (AccountContactRelation acr : [SELECT AccountId FROM AccountContactRelation WHERE Relacionamento__c = 'Cônjuge/Companheiro']) {
        if (!accountSpouseCount.containsKey(acr.AccountId)) {
            accountSpouseCount.put(acr.AccountId, 0);
        }
        accountSpouseCount.put(acr.AccountId, accountSpouseCount.get(acr.AccountId) + 1);
    }

    // Verifica os registros sendo inseridos ou atualizados
    for (AccountContactRelation acr : Trigger.new) {
        if (acr.Relacionamento__c == 'Cônjuge/Companheiro') {
            Integer existingCount = accountSpouseCount.get(acr.AccountId);
            if (existingCount == null) {
                existingCount = 0;
            }
            
            // Incrementa a contagem se o registro atual não for uma atualização de um registro existente com o mesmo relacionamento
            if (!(Trigger.isUpdate && Trigger.oldMap.get(acr.Id).Relacionamento__c == 'Cônjuge/Companheiro')) {
                existingCount++;
            }

            if (existingCount > 1) {
                acr.Relacionamento__c.addError('Apenas um contato relacionado pode ter o relacionamento marcado como "Cônjuge/Companheiro" por conta.');
            } else {
                accountSpouseCount.put(acr.AccountId, existingCount);
            }
        }
    }
}