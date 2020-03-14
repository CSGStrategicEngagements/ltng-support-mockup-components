/**
 * Controller for the Mockup Components
 * (now working with files)
 **/
global with sharing class ltng_MockupController2 extends VisualEditor.DynamicPicklist {
	/** format of a static resource url **/
    public static final String CONTENT_URL_FORMAT = '/sfc/servlet.shepherd/version/download/{0}';
    
    /** Label for the NO CHOICE MADE on resource selection */
    public static final String RESOURCE_NAME_NOT_CHOSEN = '-- Use Manual Entry --';

    //-- settings methods

    /**
     * Determines the settings for the Mock components.
     * @return ltng_mockupSettings__c
     */
    @AuraEnabled
    public static ltng_mockupSettings__c getSettings(){
        ltng_mockupSettings__c results = ltng_mockupSettings__c.getOrgDefaults();
        return results;
    }

    //-- image picklist options
    global override VisualEditor.DataRow getDefaultValue() {
        VisualEditor.DynamicPickListRows allValues = getValues();
        VisualEditor.DataRow row = new VisualEditor.DataRow(
            RESOURCE_NAME_NOT_CHOSEN,
            null
        );

        if (allValues.size() > 0) {
            row = allValues.getDataRows()[0];
        }

        return row;
    }

    /**
     * Lists all the files as options
     */
    global override VisualEditor.DynamicPickListRows getValues() {
        VisualEditor.DataRow row;
        VisualEditor.DynamicPickListRows myValues = new VisualEditor.DynamicPickListRows();

        for (ContentDocument fileContent : [
            SELECT Id, Title, LatestPublishedVersionId
            FROM ContentDocument
        ]){
            row = new VisualEditor.DataRow(fileContent.Title, String.valueOf(fileContent.Id));
            myValues.addRow(row);
        }

        return myValues;
    }

    //-- image methods

    /**
     * Determines the URL for the latest contentVersion of a content
     * @param contentId (Id) - Id of the content we want
     * @return String - url for that content
     */
    @AuraEnabled
    public static String determineContentURL(Id contentId) {
        String result = '';
        
        ContentDocument content = [
            SELECT Id, Title, LatestPublishedVersionId
            FROM ContentDocument
            WHERE id = :contentId
        ];

        return String.format(
            CONTENT_URL_FORMAT,
            new String[]{
                content.LatestPublishedVersionId
            }
        );
    }
}