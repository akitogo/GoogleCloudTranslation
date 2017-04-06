# GoogleCloudTranslation
Implements Google Cloud Translation Api for Coldbox Coldfusion
See https://cloud.google.com/translate/
as well https://cloud.google.com/translate/docs/

## Installation 
You will need a Google Account to work with this API
As well you need to set up Google Cloud APIs
See here: https://cloud.google.com/translate/docs/getting-started


This API can be installed as standalone or as a ColdBox Module.  Either approach requires a simple CommandBox command:

```
box install GoogleCloudTranslation
```

Then follow either the standalone or module instructions below.

### Standalone

This API will be installed into a directory called `GoogleCloudTranslation` and then the API can be instantiated via ` new GoogleCloudStoreage.models.GoogleCloudTranslation()` with the following constructor arguments:

```
<cfargument name="apiKey" 			required="true">
```

### ColdBox Module

This package also is a ColdBox module as well.  The module can be configured by creating an `GoogleSettings` configuration structure in your application configuration file: `config/Coldbox.cfc` with the following settings:

```
	// Your Google API Key
	GoogleApiKey = "",
};
```

Then you can leverage the API CFC via the injection DSL: `GoogleTranslation@GoogleCloudTranslation`

## Usage
```
/**
* A normal ColdBox Event Handler
*/
component{
	property name="ggl" inject="GoogleTranslation@GoogleCloudTranslation";
	
	function index(event,rc,prc){

		
		// returns an array of supported language codes
		var l=ggl.getLanguages();
		writeDump(l);
		
		// returns true
		writeDump(ggl.isSupportedLanguage('de'));
		
		// returns false
		writeDump(ggl.isSupportedLanguage('XX'));

		// returns translated text as string
		var t=ggl.translate('Italy, Tuscany, View out of window to the garden of land house','en','de');
		writeDump(t);
		abort;
		
		// detects language of a text
		// returns a struct with three values
		var t=ggl.detect('Italy, Tuscany, View out of window to the garden of land house.');
		writeDump(t);

		var t=ggl.detect('Dies ist ein kurzer deutscher Text');
		writeDump(t);		
	}
}
```

## Written by
www.akitogo.com

## Disclaimer
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
