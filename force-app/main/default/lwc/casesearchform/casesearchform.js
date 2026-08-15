import { LightningElement, track } from 'lwc';
import casesearchmethod from '@salesforce/apex/CaseSearchController.casesearchmethod';

export default class casesearchform extends LightningElement {
    @track cases;
    @track error;
    @track caseNumbers;

    columns = [
        { label: 'Case Number', fieldName: 'CaseNumber', type: 'text' },
        { label: 'Subject', fieldName: 'Subject', type: 'text' },
        { label: 'Origin', fieldName: 'Origin', type: 'text' }
    ];

    handlechange(event) {
        this.caseNumbers = event.target.value;
    }

    handleSubmit() {
        this.cases = null;
        this.error = null;

        casesearchmethod({ caseNumbers: this.caseNumbers })
            .then(data => {
                this.cases = data;
                this.cases.forEach(c => {
                    console.log(`CaseNumber: ${c.CaseNumber}, Subject: ${c.Subject}, Status: ${c.Status}`);
                });
            })
            .catch(error => {
                this.error = error.body.message;
            }
            );
    }

}