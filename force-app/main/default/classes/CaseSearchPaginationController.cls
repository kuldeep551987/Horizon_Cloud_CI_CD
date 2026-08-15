public class CaseSearchPaginationController {

    public String searchText { get; set; }
    public ApexPages.StandardSetController ssc { get; set; }
    public Integer pageSize { get; set; }

    public CaseSearchPaginationController() {
        pageSize = 5;
    }

    public void searchCases() {

        if (String.isBlank(searchText)) {
            ssc = null;
            return;
        }

        String soql =
            'SELECT Id, CaseNumber, Subject, Status, Priority, CreatedDate ' +
            'FROM Case ' +
            //'WHERE Subject LIKE :(\'%' + searchText + '%\') ' +
            'ORDER BY CreatedDate DESC';

        ssc = new ApexPages.StandardSetController(Database.getQueryLocator(soql));
        ssc.setPageSize(pageSize);
    }

    public List<Case> getCases() {
        return (ssc == null) ? new List<Case>() : (List<Case>) ssc.getRecords();
    }

    public void next() {
        if (ssc != null) ssc.next();
    }

    public void previous() {
        if (ssc != null) ssc.previous();
    }

    public Boolean getHasNext() {
        return ssc != null && ssc.getHasNext();
    }

    public Boolean getHasPrevious() {
        return ssc != null && ssc.getHasPrevious();
    }
}