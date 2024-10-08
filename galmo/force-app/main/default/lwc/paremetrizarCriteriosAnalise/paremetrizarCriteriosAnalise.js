import criarConjuntoCriterios from '@salesforce/apex/ParametrizarCriteriosController.criarConjuntoCriterios';
import getVariacoesLimite from '@salesforce/apex/ParametrizarCriteriosController.getVariacoesLimite';
import testarConjuntoCriterios from '@salesforce/apex/ParametrizarCriteriosController.testarConjuntoCriterios';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { LightningElement, wire } from 'lwc';

export default class ParametrizarCriteriosAnalise extends LightningElement {
    limiteOptions = [];

    @wire(getVariacoesLimite)
    wiredVariacoes({ error, data }) {
        if (data) {
            this.limiteOptions = data.map(item => {
                return { label: item, value: item };
            });
        } else if (error) {
            console.error('Erro ao buscar variações', error);
        }
    }

    // variaveis de inputs
    valorNominal = 0;
    valorVpl = 0;
    valorMetro = 0;
    valorPrazo = 0;
    valorCaptacaoVista = 0;
    valorCaptacaoPos = 0;
    valorCaptacaoMensal = 0;

    // variaveis de variações
    variacaoNominal = '';
    variacaoVpl = '';
    variacaoMetro = '';
    variacaoPrazo = '';
    variacaoCaptacaoVista = '';
    variacaoCaptacaoPos = '';
    variacaoCaptacaoMensal = '';

    //variaveis de visibilidade
    showPorcentagemCapVista = true;
    showPorcentagemNominal = true;
    showPorcentagemVpl = true;
    showPorcentagemMetro = true;
    showPorcentagemCapPos = true;
    showPorcentagemCapMensal = true;

    displayTeste = false;

    limite = [];

    // formatação do campo Nominal
    get valorNominalDisplay() {
        return this.showPorcentagemNominal ? `${this.valorNominal}%` : this.valorNominal;
    }

    adicionarPorcentagemNominal() {
        if (!isNaN(this.valorNominal) && this.valorNominal !== '') {
            this.showPorcentagemNominal = true;
        }
    }

    handleMudancaNominal(event) {
        const inputValue = parseFloat(event.target.value);
        if (!isNaN(inputValue)) {
            this.valorNominal = inputValue;
        } else {
            this.valorNominal = 0;
        }
    }

    retirarPorcentagemNominal() {
        this.showPorcentagemNominal = false;
    }

    handleMudancaLimiteNominal(event) {
        this.variacaoNominal = event.target.value;
        if (this.bloqueioInputNominal) {
            this.valorNominal = 0;
        }
    }

    get bloqueioInputNominal() {
        if (this.variacaoNominal === 'Não for igual'){
            return true;
        } else {
            return false;
        }
    }

    // formatação do campo VPL

    get valorVplDisplay(){
        return this.showPorcentagemVpl ? `${this.valorVpl}%` : this.valorVpl;
    }

    retirarPorcentagemVpl() {
        this.showPorcentagemVpl = false;
    }

    adicionarPorcentagemVpl() {
        if (!isNaN(this.valorVpl) && this.valorVpl !== '') {
            this.showPorcentagemVpl = true;
        }
    }

    handleMudancaVpl(event) {
        const inputValue = parseFloat(event.target.value);
        if (!isNaN(inputValue)) {
            this.valorVpl = inputValue;
        } else {
            this.valorVpl = 0;
        }
    }

    handleMudancaLimiteVPL(event){
        this.variacaoVpl = event.target.value;
        if (this.bloqueioInputVpl) {
            this.valorVpl = 0;
        }
    }

    get bloqueioInputVpl(){
        if (this.variacaoVpl === 'Não for igual'){
            this.valorVpl = 0;
            return true;
        } else {
            return false;
        }
    }

    // formatação do campo Metro²

    get valorMetroDisplay(){
        return this.showPorcentagemMetro ? `${this.valorMetro}%` : this.valorMetro;
    }
    retirarPorcentagemMetro(){
        this.showPorcentagemMetro = false;
    }
    adicionarPorcentagemMetro(){
        if (!isNaN(this.valorMetro) && this.valorMetro !== '') {
            this.showPorcentagemMetro = true;
        }
    }

    handleMudancaMetro(){
        const inputValue = parseFloat(event.target.value);
        if (!isNaN(inputValue)) {
            this.valorMetro = inputValue;
        }
    }

    handleMudancaLimiteMetro(event) {
        this.variacaoMetro = event.target.value;
        if (this.bloqueioInputMetro) {
            this.valorMetro = 0;
        }
    }

    get bloqueioInputMetro(){
        if (this.variacaoMetro === 'Não for igual'){
            return true;
        } else {
            return false;
        }
    }

    // formatação do campo Prazo Financiamento

    get valorPrazoDisplay(){
        return this.valorPrazo;
    }

    handleMudancaPrazo(event){
        const inputValue = parseFloat(event.target.value);
        if (!isNaN(inputValue)) {
            this.valorPrazo = inputValue;
        }
    }

    handleMudancaLimitePrazo(event) {
        this.variacaoPrazo = event.target.value;
        if (this.bloqueioInputPrazo) {
            this.valorPrazo = 0;
        }
    }

    get bloqueioInputPrazo() {
        if (this.variacaoPrazo === 'Não for igual'){
            return true;
        } else {
            return false;
        }
    }

    // formatação do campo de % captação a vista

    get valorCaptacaoVistaDisplay(){
        return this.showPorcentagemCapVista ? `${this.valorCaptacaoVista}%` : this.valorCaptacaoVista;
    }

    retirarPorcentagemCaptacaoVista(){
        this.showPorcentagemCapVista = false;
    }

    adicionarPorcentagemCaptacaoVista(){
        if (!isNaN(this.valorCaptacaoVista) && this.valorCaptacaoVista !== '') {
            this.showPorcentagemCapVista = true;
        }
    }

    handleMudancaCaptacaoVista(event){
        const inputValue = parseFloat(event.target.value);
        if (!isNaN(inputValue)) {
            this.valorCaptacaoVista = inputValue;
        }
    }

    handleMudancaLimiteCapVista(event) {
        this.variacaoCaptacaoVista = event.target.value;
        if (this.bloqueioInputCapVista) {
            this.valorCaptacaoVista = 0;
        }
    }

    get bloqueioInputCapVista() {
        if (this.variacaoCaptacaoVista === 'Não for igual'){
            return true;
        } else {
            return false;
        }
    }

    // formatação do campo de % captação Pos

    get valorCaptacaoPosDisplay(){
        return this.showPorcentagemCapPos ? `${this.valorCaptacaoPos}%` : this.valorCaptacaoPos;
    }

    retirarPorcentagemCaptacaoPos(){
        this.showPorcentagemCapPos = false;
    }

    adicionarPorcentagemCaptacaoPos(){
        if (!isNaN(this.valorCaptacaoPos) && this.valorCaptacaoPos !== '') {
            this.showPorcentagemCapPos = true;
        }
    }

    handleMudancaCaptacaoPos(event){
        const inputValue = parseFloat(event.target.value);
        if (!isNaN(inputValue)) {
            this.valorCaptacaoPos = inputValue;
        }
    }

    handleMudancaLimiteCapPos(event) {
        this.variacaoCaptacaoPos = event.target.value;
        if (this.bloqueioInputPos) {
            this.valorCaptacaoPos = 0;
        }
    }

    get bloqueioInputPos() {
        if (this.variacaoCaptacaoPos === 'Não for igual'){
            return true;
        } else {
            return false;
        }
    }
    // formatação captação Mensal

    get valorMensalDisplay(){
        return this.showPorcentagemCapMensal ? `${this.valorCaptacaoMensal}%` : this.valorCaptacaoMensal;
    }

    retirarPorcentagemMensal(){
        this.showPorcentagemCapMensal = false;
    }

    adicionarPorcentagemMensal(){
        if (!isNaN(this.valorCaptacaoMensal) && this.valorCaptacaoMensal !== '') {
            this.showPorcentagemCapMensal = true;
        }
    }

    handleMudancaMensal(event){
        const inputValue = parseFloat(event.target.value);
        if (!isNaN(inputValue)) {
            this.valorCaptacaoMensal = inputValue;
        }
    }

    handleMudancaLimiteMensal(event) {
        this.variacaoCaptacaoMensal = event.target.value;
        if (this.bloqueioInputMensal) {
            this.valorCaptacaoMensal = 0;
        }
    }

    get bloqueioInputMensal() {
        if (this.variacaoCaptacaoMensal === 'Não for igual'){
            return true;
        } else {
            return false;
        }
    }

    salvarConjuntoCriterios() {
        if (!this.validarCampos()) {
            return;
        }
    
        this.limite = {
            nominal: this.valorNominal,
            nominalVariacao: this.variacaoNominal,
            vpl: this.valorVpl,
            vplVariacao: this.variacaoVpl,
            metro: this.valorMetro,
            metroVariacao: this.variacaoMetro,
            prazo: this.valorPrazo,
            prazoVariacao: this.variacaoPrazo,
            captacaoVista: this.valorCaptacaoVista,
            captacaoVistaVariacao: this.variacaoCaptacaoVista,
            captacaoPos: this.valorCaptacaoPos,
            captacaoPosVariacao: this.variacaoCaptacaoPos,
            captacaoMensal: this.valorCaptacaoMensal,
            captacaoMensalVariacao: this.variacaoCaptacaoMensal
        };
    
        criarConjuntoCriterios({ conjunto: this.limite })
            .then(() => {
                this.mostrarToast('Sucesso', 'Conjunto de critérios salvo com sucesso.', 'success');
                this.limparCampos();  // Limpar os inputs após o sucesso
            })
            .catch(error => {
                this.mostrarToast('Erro', 'Falha ao salvar o conjunto de critérios.', 'error');
                console.error('Erro ao salvar conjunto de critérios', error);
            });
    }
    
    //Inicio da seção de teste

    //variaveis de tabela
    valorNominalTabelaTeste = 0;
    valorVplTabelaTeste = 0;
    valorMetroTabelaTeste = 0;
    valorPrazoTabelaTeste = 0;
    valorCapVistaTabelaTeste = 0;
    valorcapPosTabelaTeste = 5;
    valorCapMensalTabelaTeste = 0;

    //variaveis da Proposta
    valorNominalPropostaTeste = 0;
    valorVplPropostaTeste = 0;
    valorMetroPropostaTeste = 0;
    valorPrazoPropostaTeste = 0;
    valorCapVistaPropostaTeste = 0;
    valorCapPosPropostaTeste = 0;
    valorCapMensalPropostaTeste = 0;

    //variaveis de diferença
    diferencaNominal = 0;
    diferencaNominalPorcentagem = 0;
    diferencaVpl = 0;
    diferencaVplPorcentagem = 0;
    diferencaMetro = 0;
    diferencaMetroPorcentagem = 0;

    // visibilidade da seção de teste
    
    displayTest() {
        if(!this.validarCampos()){
            return;
        }

        this.displayTeste = !this.displayTeste;
        this.limite.push({
            nominal: this.valorNominal,
            nominalVariacao: this.variacaoNominal,
            vpl: this.valorVpl,
            vplVariacao: this.variacaoVpl,
            prazoFinanciamento: this.valorPrazo,
            prazoFinanciamentoVariacao: this.variacaoPrazo,
            captacaoVista: this.valorCaptacaoVista,
            captacaoVistaVariacao: this.variacaoCaptacaoVista,
            captacaoPos: this.valorCaptacaoPos,
            captacaoPosVariacao: this.variacaoCaptacaoPos,
            captacaoMensal: this.valorCaptacaoMensal,
            captacaoMensalVariacao: this.variacaoCaptacaoMensal
        })
    }

    // Valor nominal

    salvarValorNominalTab(event) {
        this.valorNominalTabelaTeste = event.target.value;
    }

    salvarValorNominalProp(event) {
        this.valorNominalPropostaTeste = event.target.value;

        testarConjuntoCriterios({valorTabela:this.valorNominalTabelaTeste , valorProposta: this.valorNominalPropostaTeste})
            .then(result => {
                this.diferencaNominal = this.formatarMoedaBrasileira(result[0]);
                this.diferencaNominalPorcentagem = this.formatarPorcentagem(result[1]);
                console.log(JSON.stringify(result));
            })
            .catch(error => {
                console.error('Erro ao calcular a diferença:', error);
            })
    }

    // Valor Vpl

    salvarValorVplTab(event) {
        this.valorVplTabelaTeste = event.target.value;
    }

    salvarValorVplProp(event) {
        this.valorVplPropostaTeste = event.target.value;

        testarConjuntoCriterios({ valorTabela: this.valorVplTabelaTeste, valorProposta: this.valorVplPropostaTeste })
            .then(result => {
                this.diferencaVpl = this.formatarMoedaBrasileira(result[0]);
                this.diferencaVplPorcentagem = this.formatarPorcentagem(result[1]);
                console.log(JSON.stringify(result));
            })
            .catch(error => {
                console.error('Erro ao calcular a diferença:', error);
            });
    }

    // Valor M²

    salvarValorMetroTab(event) {
        this.valorMetroTabelaTeste = event.target.value;
    }

    salvarValorMetroProp(event) {
        this.valorMetroPropostaTeste = event.target.value;
        
        testarConjuntoCriterios({valorTabela: this.valorMetroTabelaTeste, valorProposta: this.valorMetroPropostaTeste})
            .then(result => {
                this.diferencaMetro = this.formatarMoedaBrasileira(result[0]);
                this.diferencaMetroPorcentagem = this.formatarPorcentagem(result[1]);
            })
    }

    // Prazo Financiamento

    salvarValorPrazoTab(event){
        this.valorPrazoTabelaTeste = event.target.value;
    }

    salvarValorPrazoProp(event) {
        this.valorPrazoPropostaTeste = event.target.value;
    }

    // % captação à vista

    salvarValorCapVistaTab(event) {
        let valor = event.target.value;
        if (valor != NaN && valor != undefined ) {this.valorCapVistaTabelaTeste = valor / 100;}
    }
    

    get adicionarPorcentagemCapVistaTabela() {
        console.log(this.valorcapPosTabelaTeste)
        return this.formatarPorcentagem(this.valorCapVistaTabelaTeste)
    }

    salvarValorCapVistaProp(event) {
        let valor = event.target.value;
        this.removerPorcentagem(valor);
        if (valor != NaN && valor != undefined){this.valorCapVistaPropostaTeste = valor / 100}
    }

    get adicionarPorcentagemCapVistaProposta() {
        return this.formatarPorcentagem(this.valorCapVistaPropostaTeste )
    }

    get limiteTesteCapVista(){
        return this.calcularLimitePorcentagem(this.valorCaptacaoVista, this.valorCapVistaTabelaTeste);
    }

    // % de captação Pos habita-se

    salvarValorCapPosTab(event) {
        let valor = event.target.value;
        if(valor != NaN && valor != undefined){this.valorCapPosTabelaTeste = valor / 100;}
    }

    get AdicionarPorcentagemCapPosTabelaTeste() {
        return this.formatarPorcentagem(this.valorCapPosTabelaTeste);
    }

    get AdicionarPorcentagemCapPosTabela() {
    }



    salvarValorCapPosProp(event) {
        let valor = event.target.value;
        if(valor != NaN && valor != undefined){this.valorCapPosPropostaTeste = valor / 100;}
    }

    get AdicionarPorcentagemCapPosProposta() {
        return this.formatarPorcentagem(this.valorCapPosPropostaTeste);
    }

    // % captação Mensal

    salvarValorCapMensalTab(event) {
        let valor = event.target.value;
        if(valor != NaN && valor != undefined){this.valorCapMensalTabelaTeste = valor / 100;}
    }

    get AdicionarPorcentagemCapMensalTabela() {
        return this.formatarPorcentagem(this.valorCapMensalTabelaTeste)
    }

    salvarValorCapMensalProp(event) {
        let valor = event.target.value;
        if(valor != NaN && valor != undefined){this.valorCapMensalPropostaTeste = valor / 100}
    }

    get AdicionarPorcentagemCapMensalProposta() {
        return this.formatarPorcentagem(this.valorCapMensalPropostaTeste)
    }


    // funções utilitarias

    calcularLimitePorcentagem(ValorLimite, valorTeste){
        let v1 = ValorLimite / 100;
        let v2 = valorTeste / 100;

        return v1 * v2 ;
    }

    validarCampos() {
        const campos = [
            { valor: this.valorNominal, nome: 'Valor Nominal' },
            { valor: this.valorVpl, nome: 'Valor VPL' },
            { valor: this.valorMetro, nome: 'Valor Metro²' },
            { valor: this.valorPrazo, nome: 'Prazo Financiamento' },
            { valor: this.valorCaptacaoVista, nome: 'Captação à Vista' },
            { valor: this.valorCaptacaoPos, nome: 'Captação Pós Habita-se' },
            { valor: this.valorCaptacaoMensal, nome: 'Captação Mensal' },
            { valor: this.variacaoNominal, nome: 'Variacao Nominal'},
            { valor: this.variacaoVpl, nome: 'Variação VPL'},
            { valor: this.variacaoMetro, nome: 'Variação Metro'},
            { valor: this.variacaoPrazo, nome: 'Variação Prazo'},
            { valor: this.variacaoCaptacaoVista, nome: 'Variação Captação a Vista'},
            { valor: this.variacaoCaptacaoPos, nome: 'Variação Captação Pos'},
            { valor: this.variacaoCaptacaoMensal, nome: 'Variação Captação Mensal'},
        ];

        for (let campo of campos) {
            if (campo.valor === null || campo.valor === undefined || campo.valor === '' || campo.valor < 0) {
                this.mostrarToast('ERRO', `O campo ${campo.nome} não pode ser vazio ou abaixo de 0.`, 'error');
                return false;
            }
        }
        return true;
    }

    mostrarToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(event);
    }

    limparCampos() {
        this.valorNominal = 0;
        this.variacaoNominal = '';
        this.valorVpl = 0;
        this.variacaoVpl = '';
        this.valorMetro = 0;
        this.variacaoMetro = '';
        this.valorPrazo = 0;
        this.variacaoPrazo = '';
        this.valorCaptacaoVista = 0;
        this.variacaoCaptacaoVista = '';
        this.valorCaptacaoPos = 0;
        this.variacaoCaptacaoPos = '';
        this.valorCaptacaoMensal = 0;
        this.variacaoCaptacaoMensal = '';
    }

    formatarMoedaBrasileira(valor) {
        const valorNumerico = parseFloat(valor);
        return valorNumerico.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' });
    }

    formatarPorcentagem(valor) {    
        const valorNumerico = parseFloat(valor);
        return valorNumerico.toLocaleString('pt-BR', { style: 'percent', minimumFractionDigits: 2});
    }

    removerPorcentagem(event) {
        let valor = event.target.value;
        valor = valor.replace('%', '');
        event.target.value = valor;
    }
}