import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class Example extends NavigationMixin(LightningElement) {
    @api recordId;
    @api redirect = false; 

    navigateToObjectHome() {
        this[NavigationMixin.GenerateUrl]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.recordId,
                actionName: 'view',
            },
        }).then((url) => {
            this.recordPageUrl = url;
        });
    }

    recordPageUrl;

    connectedCallback() {
        if (this.redirect) {
            this.navigateToObjectHome();
        }
    }
}