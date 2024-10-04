public with sharing class IntegracaoAccount {
 
    public void enviarContas(Account conta) {

        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();

        req.setEndpoint('ApiERP');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');

        if (isAccountValid(conta)) {
            String jsonBody = '{"codigo": "",'
                            + '"nome": "' + conta.Name + '",'
                            + '"cnpj": "' + conta.CNPJ__c + '",'
                            + '"cpf": "' + conta.CPF__c + '",'
                            + '"inscricaoEstadualPJ": "' + conta.InscricaoEstadual__pc + '",'
                            + '"email": "' + conta.PersonEmail + '",'
                            + '"telefone": "' + conta.Phone + '",'
                            // + '"tipoLogradouro": "' + conta.TipoLogradouro__c + '",'
                            + '"endereco": {'
                                + '"logradouro": "' + conta.Logradouro__pc + '",'
                                + '"numero": "' + conta.Numero__pc + '",' 
                                + '"bairro": "' + conta.Bairro__pc + '",' 
                                + '"municipio": "' + conta.Cidade__pc + '",'
                                + '"cidade": "' + conta.Cidade__pc + '",' 
                                + '"estado": "' + conta.UF__pc + '",'
                                + '"pais": "' + conta.Pais__pc + '",'
                                + '"CEP": "' + conta.CEP__pc + '"'
                                + '}'
                            + '}';
        
            req.setBody(jsonBody);

            try {
                Http http = new Http();
                HTTPResponse resp = http.send(req);    
            } catch (Exception e) {
                throw new AuraHandledException('Erro ao enviar a conta: ' + e.getMessage());
            }
        }             
    }

    public Boolean isAccountValid(Account conta){
        return conta.Name != null &&
                conta.CPF__c != null && 
                conta.InscricaoEstadual__pc != null && 
                conta.PersonEmail != null && 
                conta.Phone != null && conta.Phone != '' &&
                // conta.TipoLogradouro__c != null && conta.TipoLogradouro__c != '' &&
                conta.Logradouro__pc != null && conta.Logradouro__pc != '' &&
                conta.Numero__pc != null && conta.Numero__pc != '' &&
                conta.Bairro__pc != null && conta.Bairro__pc != '' &&
                conta.Cidade__pc != null && conta.Cidade__pc != '' &&
                conta.UF__pc != null && conta.UF__pc != '' &&
                conta.Pais__pc != null && conta.Pais__pc != '' &&
                conta.CEP__pc != null && conta.CEP__pc != '';
    }

}