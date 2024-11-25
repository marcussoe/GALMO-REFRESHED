@RestResource(urlMapping='/metaphone/buscarPalavras')
global with sharing class MetaphoneController {
    
    @HttpPost
    global static void buscaNomesFoneticamente() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        String requestBody = req.requestBody.toString();
        Map<String, Object> params = (Map<String, Object>) JSON.deserializeUntyped(requestBody);
        
        String palavra = (String) params.get('palavra');
        List<Object> nomesTemp = (List<Object>) params.get('nomes');
        List<String> nomes = new List<String>();

        // Converte a lista de objetos para uma lista de strings
        for (Object nomeTemp : nomesTemp) {
            nomes.add((String) nomeTemp);
        }
        
        if (palavra == null || nomes == null) {
            res.statusCode = 400;
            res.responseBody = Blob.valueOf('Parâmetros "palavra" e "nomes" são obrigatórios.');
            return;
        }

        MetaphoneService service = new MetaphoneService();
        List<String> resultado = service.buscaFoneticamente(palavra, nomes);

        res.statusCode = 200;
        res.responseBody = Blob.valueOf(JSON.serialize(resultado));
    }
}