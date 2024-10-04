trigger ValidarCPFContaFromTrigger on Account (before insert, before update) {

   for (Account acc: Trigger.new) {
    
        if (!String.isBlank(acc.CPF__pc) && !ValidarCPF.validarCPF(acc.CPF__pc)) {
            acc.addError('CPF inválido. Por favor, insira um CPF válido.');
        }
    }

}