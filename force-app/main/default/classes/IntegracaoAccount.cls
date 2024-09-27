public with sharing class IntegracaoAccount {
 
    public void enviarContas(Account conta) {
        Account contaParaEnvio = contas;

        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();

        req.setEndpoint('ApiERP');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');




    }

}