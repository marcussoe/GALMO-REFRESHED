public with sharing class EmpreendimentoTriggerHandler extends TriggerHandler {
    public override void beforeInsert() {
        for (Enterprise__c emp : (List<Enterprise__c>) Trigger.new) {
            String cnpj = emp.CNPJ__c;
            if (!EmpreendimentoHelper.validarCNPJ(cnpj)) {
                emp.addError('CNPJ inválido. Por favor, insira um CNPJ válido. O CNPJ deve ser preenchido com apenas números');
            }
        }
    }
    
    
       public override void beforeUpdate() {
        for (Enterprise__c emp : (List<Enterprise__c >) Trigger.new) {
            String cnpj = emp.CNPJ__c;
            if (!EmpreendimentoHelper.validarCNPJ(cnpj)) {
                emp.addError('CNPJ inválido. Por favor, insira um CNPJ válido. O CNPJ deve ser preenchido com apenas números');
            }
        }
    }
}