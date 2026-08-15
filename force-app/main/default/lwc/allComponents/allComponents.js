import { LightningElement, track } from 'lwc';

export default class AllComponents extends LightningElement {
    selectedIndustry = 'IT';
industryOptions = [];
skillOptions = [];
hobbyOptions = [];
genderOptions = [];
treeItems = [];

    // Options for picklists
   industryOptions = [
    { label: 'IT', value: 'IT' },
    { label: 'Finance', value: 'Finance' },
    { label: 'Healthcare', value: 'Healthcare' }
];

skillOptions = [
    { label: 'Java', value: 'Java' },
    { label: 'Apex', value: 'Apex' },
    { label: 'LWC', value: 'LWC' }
];

hobbyOptions = [
    { label: 'Music', value: 'Music' },
    { label: 'Sports', value: 'Sports' },
    { label: 'Reading', value: 'Reading' }
];

genderOptions = [
    { label: 'Male', value: 'M' },
    { label: 'Female', value: 'F' }
];

treeItems = [
    {
        label: 'Parent 1',
        name: '1',
        expanded: true,
        items: [{ label: 'Child 1.1', name: '2' }]
    }
];


    handleChange(event) {
        console.log('Value changed: ', event.detail.value);
    }

    handleClick() {
        alert('Button clicked!');
    }
}