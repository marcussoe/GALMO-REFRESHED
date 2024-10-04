public with sharing class RedirecionamentoCorretor {

    @InvocableMethod(label='Redirecionar para Contato' description='Redireciona para a página de contato do corretor')
    public static void redirecionarParaContato(List<Id> corretorIds) {
        for (Id corretorId : corretorIds) {
            String orgURL = URL.getOrgDomainUrl().toExternalForm();
            String redirectURL = orgURL + '/lightning/r/Contact/' + corretorId + '/view';
            
            PageReference pageRef = new PageReference(redirectURL);
            pageRef.setRedirect(true);
        }
    }
}