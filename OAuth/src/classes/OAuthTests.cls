@isTest
private class OAuthTests {

	public static String createTestData() {
		OAuthService__c s = new OAuthService__c();
		s.name='test1234';
		s.request_token_url__c = 'http://requesttokenurl';
		s.access_token_url__c = 'http://requesttokenurl';
		s.consumer_key__c = 'consumerkey';
		s.consumer_secret__c = 'consumersecret';
		s.authorization_url__c = 'http://testauthorizationurl';
		insert s;
		
		Saved_URL__c u = new Saved_URL__c();
		u.Oauth_Service__c = s.id;
		u.url__c = 'http://testapiurl';
		u.method__c = 'POST';
		u.isform__c = true;
		u.body__c = 'param=test';
		
		insert u;
		return u.id;
	}
	
	public static testMethod void testGetUsersOfService() {
		OAuthTests.createTestData();
		OAuth o = new OAuth();
		o.getUsersOfService('test1234');
	}

    public static testMethod void testAuthorize() {
    	
    	try {
    		OAuthTests.createTestData();
    		Test.setCurrentPage(Page.AuthPage);
    		ApexPages.currentPage().getHeaders().put('Host','testhost');
    		AuthController ac = new AuthController();
    		ac.service = 'test1234';
    		ac.authUrl = 'bogus';
    		ac.message = 'bogus';
    		System.assert(ac.services.size()>0);
    		ac.authorize();
    		Test.setCurrentPage(Page.CompleteAuth);
	        ApexPages.currentPage().getParameters().put('oauth_token','token');
	        ApexPages.currentPage().getParameters().put('oauth_verifier','verifier');
    		ac.completeAuthorization();

    	}
    	catch(Exception e) {
			throw e;
    	}
    }
    
    public static testMethod void testTestController() {
    	
    	try {
    		String savedURLID = OAuthTests.createTestData();
    		Test.setCurrentPage(Page.ApiTestPage);
    		TestController tc = new TestController();
    		
    		System.assert(tc.methodList.size()>1);
    		
    		tc.selectedService = 'test1234';
    		
    		System.assert(tc.savedURLs.size()==1);
    		System.assert(tc.services.size()>0);
    		
    		tc.url = 'http://testurl';
    		tc.method='GET';
    		tc.postParam = '';
    		tc.body = '';
    		tc.selectedService = 'test1234';
    		tc.saveURL();
    		
    		tc.selectedSavedURL = savedURLID;
    		
    		tc.loadURL();
    		
    		tc.execute();

    	}
    	catch(Exception e) {
			throw e;
    	}
    }
    
}