public with sharing class AuthController {

    public String service { get; set; }
    
    public String authUrl { get; set; }
    
    public boolean authSuccess { get; set; }

    public String message { get; set; }

    public List<SelectOption> services {
        get {
            if(services==null) {
                List<OAuthService__c> l = [SELECT name FROM OAuthService__c];
                services = new List<SelectOption>();
                for(OAuthService__c obj : l) {
                    services.add(new SelectOption(obj.name,obj.name));
                    System.debug('service: '+obj.name);
                }
            }
            return services;
        }
        set;
    }
    
    public PageReference authorize() {
        OAuth oa = new OAuth();
        authUrl = oa.newAuthorization(service);
        System.debug(authUrl);
        if(authUrl==null) {
        	this.message = oa.message;
        	return null;
        } else {
        	return new PageReference(authUrl);
        }
    }
    
    public PageReference completeAuthorization() {
        String token = ApexPages.currentPage().getParameters().get('oauth_token');
        if(token!=null)
        {
            String verifier = ApexPages.currentPage().getParameters().get('oauth_verifier');
            OAuth oa = new OAuth();
            authSuccess = oa.completeAuthorization(token,verifier);
            this.message = oa.message;
        }
        else {
            message = 'Invalid request. Missing parameter oauth_token';
        }
        return null;
    }
}
/**

POST&https%3A%2F%2Fwww.google.com%2Faccounts%2Foauthgetrequesttoken&oauth_callback%3Dhttps%253A%252F%252Fc.na7.visual.force.com%252Fapex%252Fcompleteauth%26oauth_consumer_key%3Doauth-developer-edition.na7.force.com%26oauth_nonce%3D1077624789854119623%26oauth_signature_method%3DHMAC-SHA1%26oauth_timestamp%3D1259401228%26scope%3Dhttp%253A%252F%252Fwww.google.com%252Fcalendar%252Ffeeds%252F
POST&https%3A%2F%2Fwww.google.com%2Faccounts%2FOAuthGetRequestToken&oauth_callback%3Dhttps%253A%252F%252Fc.na7.visual.force.com%252Fapex%252Fcompleteauth%26oauth_consumer_key%3Doauth-developer-edition.na7.force.com%26oauth_nonce%3D1077624789854119623%26oauth_signature_method%3DHMAC-SHA1%26oauth_timestamp%3D1259401228%26scope%3Dhttp%253A%252F%252Fwww.google.com%252Fcalendar%252Ffeeds%252F

*/