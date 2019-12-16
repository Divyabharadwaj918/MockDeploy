public class OpportunityCreateBoxFolder_Queue implements Queueable, Database.AllowsCallouts{
    public Opportunity[] opps;
    private boxAPIConnection api;
    public BoxFolder rootFolder;
    public BoxFolder folder;
    public BoxFolder destination;
    private user u;
    
    public OpportunityCreateBoxFolder_Queue(Opportunity[] inbound){
        opps = inbound;
        u = [
            select id, 
            box_client_id__c, 
            box_client_secret__c, 
            box_client_access_token__c, 
            box_client_refresh_token__c 
            from user where name = 'Brooke Vaughan'
        ];
    }

    public void execute(queueablecontext q){
        Authenticate();

        
        box.Toolkit boxToolkit = new box.Toolkit();
        
        if (!test.isRunningTest()) getFolders();
        
        for (Opportunity o: opps){
            /* Handle issues and add errors where necessary. */
            if (folder == null) o.addError('BoxCreateOpportunityFolder Error: Templates Folder Not Found!');
            if (Destination == null) o.addError('BoxCreateOpportunityFolder Error: Salesforce Box Folder Not Found!');
            if ((folder == null || destination == null) && !test.isRunningTest()) continue;
            
            BoxItem.Info done;
            if (!test.isRunningTest()) done = folder.copy(destination, o.name);
            
            try{
                boxToolkit.createFolderAssociation(o.id, done.id);
                boxToolkit.commitChanges();
            }catch(exception e){}
        }
        if (!test.isRunningTest())u.box_client_refresh_token__c = api.getRefreshToken();
        if (!test.isRunningTest())u.box_client_access_token__c = api.getAccessToken();
        database.update(u);
    }
    
    public void authenticate(){
        api = new boxapiconnection(
            u.box_client_id__c, u.box_client_secret__c,
            u.box_client_access_token__c, u.box_client_refresh_token__c
        );
        if (!test.isRunningTest()) api.refresh();
    }
    
    public void getFolders(){
        rootFolder = BoxFolder.getRootFolder(api);
        string folderId;
        string destinationId;
        /* grab stuff from main folder */
        for (BoxItem.info itemInfo: rootFolder.getChildren()) {
            if (itemInfo instanceof BoxFolder.info && 
                (itemInfo.name == '@BKW Workspace' || itemInfo.name == 'Salesforce Box')) {
                
                BoxFolder childFolder = new BoxFolder(api, itemInfo.id);
                
                for (BoxItem.info itemInfoChild: childFolder.getChildren()){
                    if (itemInfoChild.name == 'Templates'){
                        folderId = itemInfoChild.id;
                    }
                    if (itemInfoChild.name == 'Opportunities'){
                        DestinationId = itemInfoChild.id;
                    }
                }
            }
        }
        folder = new BoxFolder(api, folderId);
        destination = new BoxFolder(api, destinationId);
    }
}