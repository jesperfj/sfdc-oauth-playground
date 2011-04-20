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