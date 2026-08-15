import { LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class CaseCreateForm extends NavigationMixin(LightningElement) {

    handleSuccess(event) {
        const recordId = event.detail.id;

        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId,
                objectApiName: 'Case',
                actionName: 'view'
            }
        });
    }

    handleError(event) {
        console.error('Error:', event.detail);
    }

    handleCancel() {
        window.history.back();
    }
}