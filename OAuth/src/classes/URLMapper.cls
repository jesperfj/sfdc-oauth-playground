global class URLMapper implements Site.UrlRewriter {
    global PageReference mapRequestUrl(PageReference requestUrl) {
        System.debug('mapRequestUrl: '+requestUrl.getUrl());
        return Page.Front;
    }
    
    global PageReference[] generateUrlFor(PageReference[] generatedUrls) {
        return generatedUrls;   
    }
}