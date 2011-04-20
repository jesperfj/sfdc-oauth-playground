public class TestController {

	private Saved_URL__c selectedSavedURLObj;
	
    public String body { get; set; }
    public String method { get; set; }
    public String postParam { get; set; }
    public String url { get; set; }

    public String message { get; set; }
    
    public List<SelectOption> methodList { 
    	get {
    		if(methodList==null) {
    			methodList = new List<SelectOption>();
    			methodList.add(new SelectOption('GET','GET'));    			
    			methodList.add(new SelectOption('POST','POST'));
    			methodList.add(new SelectOption('PUT','PUT'));
    		}
    		return methodList;
    	}
    	set;
    }
    private Map<String,OAuthService__c> oauthServices {
    	get {
    		if(oauthServices==null) {
    			oauthServices = new Map<String,OAuthService__c>(); 
    			for(OAuthService__c o : 
    					[SELECT name, 
    					 (SELECT id, url__c, body__c, isform__c, method__c FROM Saved_URLs__r) 
    					 FROM OAuthService__c]) {
    				oauthServices.put(o.name,o);
    			}
    		}
    		return oauthServices;
    	}
    	set;
    }

    public String selectedService { 
    	get {
    		if(selectedService==null && oauthServices.size()>0) {
    			selectedService = oauthServices.values()[0].name;
    		}
    		return selectedService;
    	}
    	set; 
    }

    public List<SelectOption> services {
        get {
            services = new List<SelectOption>();
	        for(OAuthService__c obj : oauthServices.values()) {
                services.add(new SelectOption(obj.name,obj.name));
            }
            return services;
        }
        set;
    }
    
    public String selectedSavedURL { 
    	get {
    		if(selectedSavedURLObj==null && oauthServices.get(selectedService).saved_urls__r.size()>0) {
    			selectedSavedURLObj = oauthServices.get(selectedService).saved_urls__r[0];
    		}
    		return selectedSavedURLObj!=null ? selectedSavedURLObj.id : null;
    	} 
    	set {
			for(Saved_URL__c u : oauthServices.get(selectedService).saved_urls__r) {
				if(u.id == value) {
					selectedSavedURLObj = u;
				}
			}
    	} 
    }

    public List<SelectOption> savedURLs {
    	get {
    		List<SelectOption> l = new List<SelectOption>();
    		if(selectedService!=null) {
    			for(Saved_URL__c u : oauthServices.get(selectedService).saved_urls__r) {
					l.add(new SelectOption(u.id,u.url__c));
				}
    		}
    		return l;
    	}
    }

    public PageReference execute() {
        System.debug('Method: '+method+', Service: '+selectedService+'. URL: '+url);
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod(method);
        req.setEndpoint(url);
        if(method=='POST' || method=='PUT') {
        	if(postParam!=null & postParam!='') {
	        	req.setBody(postParam);
				req.setHeader('Content-Type','application/x-www-form-urlencoded');
			} else {
				req.setBody(body);
			}
        }
        OAuth oa = new OAuth();
        if(!oa.setService(selectedService)) {
        	System.debug(oa.message);
        	message=oa.message;
        	return null;
        }
        oa.sign(req);
        System.debug('Sending request...');
        HttpResponse res = h.send(req);
        body = res.getBody();
        System.debug('Received response ('+res.getStatusCode()+' '+res.getStatus()+')');
        message = '';
        return null;
    }

	public PageReference saveURL() {
		Saved_URL__c s = new Saved_URL__c();
		s.url__c = url;
		s.method__c = method;
		if(postParam!=null && postParam!='') {
	        s.body__c = postParam;
	        s.isform__c = true;
		} else {
			s.body__c = body;
			s.isform__c = false;
		}
		s.oauth_service__c = oauthServices.get(selectedService).id;
		insert s;
		oauthServices=null;
		return null;
	}

	public PageReference loadURL() {
		url = selectedSavedURLObj.url__c;
		method = selectedSavedURLObj.method__c;
		if(selectedSavedURLObj.isform__c) {
			postParam = selectedSavedURLObj.body__c;
		} else {
			body = selectedSavedURLObj.body__c;
		}
		return null;
	}
}