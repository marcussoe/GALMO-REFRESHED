import { LightningElement, api, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class EspelhoVendasCard extends NavigationMixin(LightningElement) {
    @api empreendimento;
    @api id;
    @api unidade;
    @api status;
    @api valor;
    @api link;
    @api area;
    @api quartos;
    @api vagas;
    @api tipo;
    @api andar;
    @track unitClass;
    @track tooltipClass = 'slds-popover slds-popover_small slds-nubbin_top slds-is-absolute slds-hide tooltip';

    connectedCallback() {
        this.updateUnitClass();
    }

    simularVenda() {
        this[NavigationMixin.Navigate]({
            type: 'standard__navItemPage',
            attributes: {
                apiName: 'Simulador_de_Vendas'
            }
        })
    }
    
    irParaUnidade() {
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: `${this.link}`
            }
        })
    }

    exibirTooltip() {
        this.tooltipClass = 'slds-popover slds-popover_small slds-nubbin_top slds-is-absolute tooltip';
    }

    fecharTooltip(event) {
        const isMouseOverTooltip = this.isMouseOverElement(event, this.template.querySelector('.slds-popover'));
        if (!isMouseOverTooltip) {
            this.tooltipClass = 'slds-popover slds-popover_small slds-nubbin_top slds-is-absolute tooltip slds-popover_hide';
            this.mostrarPopover = false;
        } else {
            this.mostrarPopover = true;
        }
    }

    isMouseOverElement(event, element) {
        const bounds = element.getBoundingClientRect();
        return (
            event.clientX >= bounds.left &&
            event.clientX <= bounds.right &&
            event.clientY >= bounds.top &&
            event.clientY <= bounds.bottom
        );
    }

    updateUnitClass() {
        switch (this.status) {
            case 'Reservada':
                this.unitClass = 'slds-is-relative reservada slds-badge badgeUnit';
                break;

            case 'Pré-Escritura':
                this.unitClass = 'slds-is-relative preEscritura slds-badge badgeUnit';
                break;

            case 'Livre':
                this.unitClass = 'slds-is-relative livre slds-badge badgeUnit'
                break;

            case 'Vendida':
                this.unitClass = 'slds-is-relative vendida slds-badge badgeUnit'
                break;

            case 'Alugada':
                this.unitClass = 'slds-is-relative alugada slds-badge badgeUnit'
                break;

            case 'Em Negociação':
                this.unitClass = 'slds-is-relative emNegociacao slds-badge badgeUnit'
                break;

            case 'Assinatura de contrato':
                this.unitClass = 'slds-is-relative assinaturaDeContrato slds-badge badgeUnit'
                break;

            case 'Permutada':
                this.unitClass = 'slds-is-relative permuta slds-badge badgeUnit'
                break;

            case 'Bloqueada':
                this.unitClass = 'slds-is-relative bloqueada slds-badge badgeUnit'
                break;

            default:
                this.unitClass = '';
        }
    }
}