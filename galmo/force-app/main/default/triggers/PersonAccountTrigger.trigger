trigger PersonAccountTrigger on Account (before insert, before update) {
    // Lista de todos os valores que representam estados civis de casado
    Set<String> marriedStatuses = new Set<String>{
        'Casado(a) (União estável)', 
        'Casado(a) (Separação total)', 
        'Casado(a) (Comunhão total)', 
        'Casado(a) (Comunhão parcial)'
    };

    for (Account acc : Trigger.new) {
        // Verifica se o campo Estado Civil está sendo atualizado ou definido para um estado civil de casado
        if (marriedStatuses.contains(acc.EstadoCivil__pc)) {
            Boolean wasPreviouslyMarried = false;

            // Caso seja uma atualização, verificamos o valor antigo
            if (Trigger.isUpdate) {
                Account oldAcc = Trigger.oldMap.get(acc.Id);
                wasPreviouslyMarried = marriedStatuses.contains(oldAcc.EstadoCivil__pc);
            }

            // Se não estava casado antes (ou é uma inserção), verificamos a existência de um Related Contact adequado
            if (!wasPreviouslyMarried) {
                List<AccountContactRelation> relations = [
                    SELECT Id 
                    FROM AccountContactRelation 
                    WHERE AccountId = :acc.Id AND Relacionamento__c = 'Cônjuge/Companheiro'
                ];

                if (relations.isEmpty()) {
                    acc.EstadoCivil__pc.addError('Para definir o Estado Civil como "Casado", é necessário ter um Contato Relacionado com o campo "Relacionamento" marcado como "Cônjuge/Companheiro".');
                }
            }
        }
    }
}