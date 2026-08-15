import { LightningElement } from 'lwc';
import getContacts from '@salesforce/apex/ContactController.getContacts';

export default class TestLWC extends LightningElement 
{
    searchKey = '';
    contacts = [];

    handleKeyChange(event) 
    {
        this.searchKey = event.target.value;
    }

    handleSearch() 
    {
        getContacts({ searchKey: this.searchKey })
            .then((result) => {
                this.contacts = result;
            })
            .catch((error) => {
                console.error('Error fetching contacts: ', error);
                this.contacts = [];
            });
    }
}