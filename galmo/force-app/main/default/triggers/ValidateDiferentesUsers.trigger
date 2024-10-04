trigger ValidateDiferentesUsers on OpportunityTeamMember (before insert, before update) {
    for (OpportunityTeamMember otm : Trigger.new) {
        if (otm.UserId == otm.Reportase__c) {
            otm.addError('O campo Usuário e o campo Reporta-se não podem ter o mesmo usuário selecionado. Por favor, selecione um usuário diferente no campo Reporta-se.');
        }
    }
}