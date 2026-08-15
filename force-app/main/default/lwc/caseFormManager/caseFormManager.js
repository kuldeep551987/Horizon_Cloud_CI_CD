import { LightningElement, track, api, wire } from 'lwc';
import getContactSiteStudyMap from '@salesforce/apex/CaseHelperController.getContactSiteStudyMap';
import getSiteNames from '@salesforce/apex/CaseHelperController.getSiteNames';
import getStudyNames from '@salesforce/apex/CaseHelperController.getStudyNames';

export default class caseFormManager extends LightningElement {
    @api recordId; // for edit mode
    @track selectedContact;
    @track selectedSite;
    @track selectedStudy;
conid = '003gK000005Fpx3QAC';
    @track siteOptions = [];
    @track studyOptions = [];

    handleContactChange(event) {
        this.selectedContact = event.detail.name;
        console.log(this.selectedContact);
        console.log('inside handlecontact change');
        // this.fetchOptionsForContact(this.selectedContact);)
        this.fetchOptionsForContact(this.conid);
    }

    handleSiteChange(event) {
        this.selectedSite = event.detail.value;
    }

    handleStudyChange(event) {
        this.selectedStudy = event.detail.value;
    }

    fetchOptionsForContact(contactId) {
        getContactSiteStudyMap({ contactId })
            .then(result => {
                const siteIds = result.siteIds || [];
                const studyIds = result.studyIds || [];

                if (siteIds.length > 0) {
                    getSiteNames({ siteIds }).then(siteMap => {
                        this.siteOptions = Object.entries(siteMap).map(([id, name]) => ({
                            label: name,
                            value: id
                        }));
                    });
                } else {
                    this.siteOptions = [];
                }

                if (studyIds.length > 0) {
                    getStudyNames({ studyIds }).then(studyMap => {
                        this.studyOptions = Object.entries(studyMap).map(([id, name]) => ({
                            label: name,
                            value: id
                        }));
                    });
                } else {
                    this.studyOptions = [];
                }
            })
            .catch(error => {
                console.error('Error fetching contact data:', error);
            });
    }

    handleSuccess(event) {
        // handle record save
    }
}