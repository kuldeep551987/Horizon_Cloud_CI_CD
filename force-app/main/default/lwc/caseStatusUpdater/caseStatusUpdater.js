import { LightningElement, api, wire } from 'lwc';
import { getRecord, updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import CASE_ID_FIELD from '@salesforce/schema/Case.Id';
import CASE_STATUS_FIELD from '@salesforce/schema/Case.Status';

export default class CaseStatusUpdater extends LightningElement {
    @api recordId;
    currentStatus;
    isLoading = false;

    @wire(getRecord, {
        recordId: '$recordId',
        fields: [CASE_ID_FIELD, CASE_STATUS_FIELD]
    })
    wiredCase({ error, data }) {
        if (data) {
            this.currentStatus = data.fields.Status.value;
        } else if (error) {
            console.error('Error fetching case record:', error);
            this.currentStatus = 'Unknown';
        }
    }

    get isClosed() {
        return this.currentStatus === 'Closed';
    }

    get isButtonDisabled() {
        return !this.recordId || this.isLoading || this.isClosed;
    }

    handleCloseCase() {
        if (!this.recordId) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Missing Record Id',
                    message: 'This component needs a valid Case record Id.',
                    variant: 'error'
                })
            );
            return;
        }

        if (this.isClosed) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Case Already Closed',
                    message: 'This case is already in Closed status.',
                    variant: 'info'
                })
            );
            return;
        }

        this.isLoading = true;

        const fields = {
            Id: this.recordId,
            Status: 'Closed'
        };

        updateRecord({ fields })
            .then(() => {
                this.currentStatus = 'Closed';
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Case status updated to Closed.',
                        variant: 'success'
                    })
                );
            })
            .catch((error) => {
                console.error('Error updating case status:', error);
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: error.body?.message || 'Unable to update the case status.',
                        variant: 'error'
                    })
                );
            })
            .finally(() => {
                this.isLoading = false;
            });
    }
}
