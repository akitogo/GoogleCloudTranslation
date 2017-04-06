/*

Implements Google Cloud Translation Api for Coldbox Coldfusion
See https://cloud.google.com/translate/
as well https://cloud.google.com/translate/docs/

You will need a Google Account to work with this API
As well you need to set up Google Cloud APIs
See here: https://cloud.google.com/translate/docs/getting-started

Written by Akitogo Team
http://www.akitogo.com

*/
component hint="" accessors="true" Singleton{

	property name="uri";
	property name="apiKey";

	variables.uri='https://translation.googleapis.com/language/translate/v2';
	variables.httpTimeout=5;
	
	variables.aSupportedLanguages=[];
	
	/*  
	 * 
	 */
	public GoogleTranslation function init(
		string apiKey
	) {
		variables.apikey=apiKey;
		
		//set once supported languges
		variables.aSupportedLanguages=getLanguages();
		
		return this;
	}

	/*  
	 * checks if language is supported
	 */
	public boolean function isSupportedLanguage(
		string language
	) {
		return javacast('boolean',arrayfindnocase(variables.aSupportedLanguages,language));
	}
	
	
	/*  
	 * returns supported languages
	 */
	public array function getLanguages(
	) {
		var json= sendRequest(endpoint='/languages');
		var supportedLanguages=deserializeJson(json);
		var ret =[];
		for(var el in supportedLanguages.data.languages)
			arrayAppend(ret,el.language);
		
		return ret;
	}


	/* 
	 * returns a struct with:
	 * float confidence
	 * isReliable boolean
	 * language string language guessed 
	 * @text.hint text to be detected
	 */
	public struct function detect(
		string text
	) {
		var json= sendRequest(q=text,endpoint='/detect');
		var detection=deserializeJson(json);
		
		return detection.data.detections[1][1];		
	}
	
	
	/*  
	 * @text.hint text to be translated
	 * @source.hint source language
	 * @target.hint target language
	 */
	public function translate(
		string text
		,string source=''
		,string target
	) {
		var json= sendRequest(q=text,source=source,target=target);
		var translation=deserializeJson(json);
		
		return translation.data.translations[1].translatedText;
	}


	/*  
	 * 
	 */	
	public string function sendRequest(
		// we don't need to set arguments here
	) {	 	
	    var httpService = new http(); 
	    httpService.setMethod("GET"); 
	    httpService.setCharset("utf-8"); 
	    if(structKeyExists(arguments,'endpoint'))
	    	httpService.setUrl("#variables.uri##arguments.endpoint#");
		else
	    	httpService.setUrl("#variables.uri#");
	    httpService.settimeout(variables.httpTimeout);

		// add api key first
		httpService.addParam(type="URL", name="key", value="#variables.apiKey#");

		// then loop over all arguments and add them as url parameter
		for(var param in arguments){
			if(arguments[param] neq "" and param neq "endpoint")			
		 	   httpService.addParam(type="URL", name="#param#", value="#arguments[param]#");
		}
	    var HTTPResults = httpService.send().getPrefix();
	    
	    return HTTPResults.FileContent;
	}	    
}
