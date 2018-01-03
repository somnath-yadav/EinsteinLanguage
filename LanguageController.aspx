public class LanguageController {
    
   
    public string Query {get;set;}
    public String imageTitle{get;set;}
    // You can upload the `einstein_platform.pem` into your Salesforce org as `File` sObject and read it as below
    public String getAccessToken() {
        // Ignore the File upload part and "jwt.pkcs" if you used a Salesforce certificate to sign up 
        // for an Einstein Platform account
        ContentVersion base64Content = [SELECT Title, VersionData FROM ContentVersion where Title='einstein_platform' OR  Title='predictive_services' ORDER BY Title LIMIT 1];
        String keyContents = base64Content.VersionData.tostring();
        keyContents = keyContents.replace('-----BEGIN RSA PRIVATE KEY-----', '');
        keyContents = keyContents.replace('-----END RSA PRIVATE KEY-----', '');
        keyContents = keyContents.replace('\n', '');

        // Get a new token
        JWT jwt = new JWT('RS256');
        // jwt.cert = 'JWTCert'; // Uncomment this if you used a Salesforce certificate to sign up for an Einstein Platform account
        jwt.pkcs8 = keyContents; // Comment this if you are using jwt.cert
        jwt.iss = 'developer.force.com';
        jwt.sub = 'somnath.yadav@cognizant.com';
        jwt.aud = 'https://api.metamind.io/v1/oauth2/token';
        jwt.exp = '3600';
        String access_token = JWTBearerFlow.getAccessToken('https://api.metamind.io/v1/oauth2/token', jwt);
        return access_token;    
    }

    public List<Language.Prediction> getCallLanguageUrl() {
        // Get a new token
        String access_token = getAccessToken();
        system.debug('Query:'+ Query);
        // Make a prediction using URL to a file
        //return Vision.predictUrl('https://metamind.io/images/546212389.jpg',access_token,'GeneralImageClassifier');
        //return Language.intent(Query,access_token,'KDIJEER4XD4MPTJ47HNOHIZPCM'); // To predict intent of case
        return Language.intent(Query,access_token,'CommunitySentiment');
    }


    
    
}
