public with sharing class ContatoTriggerHandler extends TriggerHandler {
    public override void beforeInsert() {
        for (Contact ctt : (List<Contact>) Trigger.new) {
            String cpf = ctt.CPF__c;
            if (string.isNotBlank(ctt.CPF__c) && !ContatoHelper.validarCPF(cpf)) {
                ctt.addError('CPF inválido. Por favor, insira um CPF válido. O CPF deve ser preenchido com 11 apenas números');
            }
        }
    }
    
    
       public override void beforeUpdate() {
        for (Contact ctt : (List<Contact>) Trigger.new) {
            String cpf = ctt.CPF__c;
            if ( string.isNotBlank(ctt.CPF__c) && !ContatoHelper.validarCPF(cpf)) {
                ctt.addError('CPF inválido. Por favor, insira um CPF válido. O CPF deve ser preenchido com apenas números');
            }
        }
    }
}