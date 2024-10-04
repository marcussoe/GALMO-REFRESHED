import { api, LightningElement, track } from 'lwc';

const tipoCondicoesPickList = [
        { label: 'teste 1', value: 'teste1' },
        { label: 'teste 2', value: 'teste2' },
        { label: 'teste 3', value: 'teste3' }
    ];

const diasVencimentoPickList = [
        { label: 'dia 1', value: '1' },
        { label: 'dia 4', value: '4' },
        { label: 'dia 5', value: '5' }
    ];

    

export default class CustomDataTable extends LightningElement {
    @api header =[];
    @api series = [];

    get getColunasHeader(){
        return this.header;
    }

    @track tipoCondicoesPickList = tipoCondicoesPickList;
    @track diasVencimentoPickList = diasVencimentoPickList;

    get getSeriesPagamentosObjetos(){
        return this.series;
    }

    handleChange(event){
        this.dispatchEvent(new CustomEvent('mudancacondicao', {
            detail: event
        }));
    }

    handleDelete(event){
        this.dispatchEvent(new CustomEvent('deletecondicao', {
            detail: event
        }));
    }







}