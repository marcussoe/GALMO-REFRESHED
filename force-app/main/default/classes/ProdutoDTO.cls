public class ProdutoDTO {
    public String idUnidade { get; set; }
    public String idEmpreendimento { get; set; }
    public String idBloco { get; set; }
    public TipoRegistro tipoRegistro { get; set; }
    public String nomeProduto { get; set; }
    public String numeroUnidade { get; set; }
    public Bloco bloco { get; set; }
    public Integer andar { get; set; }
    public Decimal valorPorM2 { get; set; }
    public Integer numeroQuartos { get; set; }
    public Integer numeroSuites { get; set; }
    public Integer numeroVagasIncorporadas { get; set; }
    public Boolean ativo { get; set; }
    public Decimal metragemPrivativaDescoberta { get; set; }
    public Decimal metragemPrivativaCoberta { get; set; }
    public Decimal metragemUnidadePrivativa { get; set; }
    public Decimal fracaoIdeal { get; set; }
    public Decimal valorMetro { get; set; }
    public Decimal coeficiente { get; set; }
    public Decimal valorBase { get; set; }
    public Decimal precoLista { get; set; }
    public Status status { get; set; }
    
    public enum TipoRegistro {
        Apartamento,
        Casa,
        Comercial,
        Lote,
        Vaga,
        Box,
        Loja
    }
    
    public enum Status {
        Livre,
        Reservada,
        Vendida,
        Permutada    // Necessita de criação no Salesforce.
    }
    
    public class Bloco{
        Integer quantidadeAndares
        Integer totalUnidades
        Date dataInício
        Date dataHabiteSe
        String CódigoBloco;
        String BplId;
        String NomeBloco
        enum tipoBloco{
            Torre,
            Ala,
            Quadra
        }
    }
    
    public static List<ProdutoDTO> parse(String json){
        return (List<ProdutoDTO>) JSON.deserialize(json, List<ProdutoDTO>.class);
    }
    
    public static Product2 toProduct(ProdutoDTO produto){
        Product2 prd = new Product2();
        prd.ExternalId = produto.idUnidade;
        prd.Enterprise__c = produto.idEmpreendimento;
        prd.Bloco__c = produto.idBloco;
        prd.Name = produto.nomeProduto;
        prd.NumeroUnidade__c = produto.numeroUnidade;
        prd.Andar__c = produto.andar;
        prd.ValorM2__c = produto.valorPorM2;
        prd.NumeroQuartos__c = produto.numeroQuartos;
        prd.NumeroSuites__c = produto.numeroSuites;
        prd.NumeroVagasIncorporadas__c = produto.numeroVagasIncorporadas;
        prd.IsActive = produto.ativo;
        prd.MetragemPrivativaDescoberta__c = produto.metragemPrivativaDescoberta;
        prd.MetragemPrivativaCoberta__c = produto.metragemPrivativaCoberta;
        prd.MetragemUnidadePrivativa__c = produto.metragemUnidadePrivativa;
        prd.FracaoIdeal__c = produto.fracaoIdeal;
        prd.ValorMetro__c = produto.valorMetro;
        prd.Coeficente__c = produto.coeficiente;
        prd.ValorBase__c = produto.valorBase;
        prd.PrecoLista__c = produto.precoLista;
        prd.Status__c = produto.status;
        
        return prd;
    }
}