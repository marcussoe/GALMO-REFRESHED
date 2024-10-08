import analisarProposta from '@salesforce/apex/comissaoController.analisarProposta';
import { LightningElement, api, track } from 'lwc';

const analiseColunasOptions = [
    { cellAttributes: { iconName: { fieldName: 'aprovado' } }},
    { label: 'Critério', fieldName: 'criterio' },
    { label: 'Tabela', fieldName: 'formattedValorTabela', type: 'text' }, 
    { label: 'Proposta', fieldName: 'formattedValorProposta', type: 'text' }, 
    { label: 'Limite', fieldName: 'dentroDoLimite', type: 'boolean' }
];

export default class SimuladorTelaExtratoAnaliseProposta extends LightningElement {
    analiseColunasOptions = analiseColunasOptions;
    @api propostasCliente;
    @api idTabelaVenda;
    @api valoresMatriz;

    @track analisePropostasCliente = [];

    get getNominalProposta(){
        return parseFloat(this.valoresMatriz.nominalProposta)
    }

    get getValorVplProposta(){
        return parseFloat(this.valoresMatriz.valorVplProposta)
    }

    get getNominalTabela(){
        return parseFloat(this.valoresMatriz.nominalTabela)
    }

    get getValorVplTabela(){
        return parseFloat(this.valoresMatriz.valorVplTabela)
    }

    get getValoresMatriz(){
        return {nominalProposta: this.getNominalProposta,
                nominalTabela: this.getNominalTabela,
                valorVplProposta: this.getValorVplProposta,
                valorVplTabela: this.getValorVplTabela}
    }

    connectedCallback() {
        let analiseList = [{aprovado: 'utility:success', 
                            criterio: "Prazo de financiamento", 
                            formattedValorTabela: "40", 
                            formattedValorProposta: "37", 
                            dentroDoLimite: true},
                            
                            {aprovado: 'utility:success', 
                            criterio: "% de Captação a vista", 
                            formattedValorTabela: "20%", 
                            formattedValorProposta: "14%", 
                            dentroDoLimite: true},

                            {aprovado: 'utility:success', 
                            criterio: "% de Captação até habitá-se", 
                            formattedValorTabela: "20%", 
                            formattedValorProposta: "14%", 
                            dentroDoLimite: true},

                            {aprovado: 'utility:error', 
                            criterio: "Valor nominal", 
                            formattedValorTabela: `R$ 457.400,00`,
                            formattedValorProposta: `R$ 457.400,00`,
                            dentroDoLimite: true},
                        
                            {aprovado: 'utility:success', 
                            criterio: "Valor VPL", 
                            formattedValorTabela: `R$ 425.750,34`,
                            formattedValorProposta: `R$ 425.750,34`,
                            dentroDoLimite: true},
                        
                            {aprovado: 'utility:success', 
                            criterio: "% de Captação mensal", 
                            formattedValorTabela: "0%",
                            formattedValorProposta: "0¨%",
                            dentroDoLimite: true},]


        this.analisePropostasCliente = analiseList;
        // this.analisarPropostaCliente();
    }


    formatValor(valor) {
        return `R$${valor.toLocaleString('pt-BR', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}`;
    }

    analisarPropostaCliente() {

        
        analisarProposta({ tabelaId: this.idTabelaVenda, proposta: this.propostasCliente, valoresMatriz: this.getValoresMatriz})
            .then(result => {
                this.analisePropostasCliente = result.map(item => {
                    return {
                        ...item,
                        formattedValorTabela: this.formatValue(item.valorTabela, item.criterio),  
                        formattedValorProposta: this.formatValue(item.valorProposta, item.criterio)  
                    };
                });
            })
            .catch(error => {
                console.error('Erro ao analisar proposta:', error);
            });
    }

    formatValue(value, criterio) {
        
        const percentageCriteria = [
            '% de Captação à vista',
            '% de Captação até habita-se',
            '% de Captação mensal'
            
        ];

        const numericOnlyCriteria = [
            'Prazo de financiamento'
        ];

        if (percentageCriteria.includes(criterio)) {
            return this.formatPercentage(value);
        } else if (numericOnlyCriteria.includes(criterio)) {
            return value; 
        } else {
            return this.formatCurrency(value);
        }
    }
    

    formatCurrency(value) {
        if (value == null || isNaN(value)) {
            return value;
        }
        return new Intl.NumberFormat('pt-BR', { 
            style: 'currency', 
            currency: 'BRL', 
            minimumFractionDigits: 2, 
            maximumFractionDigits: 2 
        }).format(value);
    }

    formatPercentage(value) {
        if (value == null || isNaN(value)) {
            return value;
        }
        return new Intl.NumberFormat('pt-BR', { 
            style: 'percent', 
            minimumFractionDigits: 2, 
            maximumFractionDigits: 2 
        }).format(value / 100);
    }
}