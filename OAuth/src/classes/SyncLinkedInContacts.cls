global class SyncLinkedInContacts implements Database.Batchable<Integer> {
	
	global Iterable<Integer> start(Database.BatchableContext ctx) {
		// http://api.linkedin.com/v1/people/%7E/connections:()
		return null;
	}
	
	global void execute(Database.BatchableContext ctx, List<Integer> scope) {
		
	}
	
	global void finish(Database.BatchableContext ctx) {
		
	}

}