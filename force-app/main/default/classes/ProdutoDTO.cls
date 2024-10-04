public class ProdutoDTO {
    public String idUnidade;
    public String idEmpreendimento;
    public String idBloco;
    public TipoRegistro tipoRegistro;
    public String nomeProduto;
    public String numeroUnidade;
    public Empreendimento empreendimento;
    public Bloco bloco;
    public Integer andar;
    public Decimal valorPorM2;
    public Integer numeroQuartos;
    public Integer numeroSuites;
    public Integer numeroVagasIncorporadas;
    public Boolean ativo;
    public Decimal metragemPrivativaDescoberta;
    public Decimal metragemPrivativaCoberta;
    public Decimal metragemUnidadePrivativa;
    public Decimal fracaoIdeal;
    public Decimal valorMetro;
    public Decimal coeficiente;
    public Decimal valorBase;
    public Decimal precoLista;
    public Status status;

    public class Empreendimento(){
        String idEmpreendimento;
        String nomeEmpreendimento;
        String cnpj;
        String spe;
        String statusObra;
    }
    
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
        Integer quantidadeAndares;
        Integer totalUnidades;
        Date dataInício;
        Date dataHabiteSe;
        String codigoBloco;
        String BplId;
        String nomeBloco;
        enum tipoBloco{
            Torre,
            Ala,
            Quadra
        }
    }
    
    public static ProdutoDTO parse(String json){
        return (ProdutoDTO) JSON.deserialize(json, ProdutoDTO.class);
    }
    
    public static Product2 toProduct(){
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