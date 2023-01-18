# IBM Cloud Object Storage Archive Restore

### This is a collection of bash and python scripts that work together to automate the restoration of all archived objects in an IBM Object Storage instance, depending on it`s last modified date. The script named "final-script.sh" is the main script, and it should be run with no arguments.
## What \"final-script.sh\"  does:
- #### Reads a \"script.conf\" file (provided by you) to get the following values:
  - APIKEY: Your IBM Cloud API Key
  - CRN: A value found in the credentials tab of your IBM Cloud Object Storage instance
  - COS_ENDPOINT: The endpoint for your COS instance can be found in the configuration tab
  - DATE: Archived objects last modified after the specified date are the ones that will be restored
  - DAYS: How many days should the object be restored for
  - TIER: This value must match the archive class of the object. Either \"Bulk\" or \"Accelerated\"
- #### Uses the provided API Key to retreive an OAUTH and saves it as \"oauth-token.json\"
- #### Parses the .json file and saves the token as \"oauth-token.txt\"
- #### Retrieves the list of buckets in the COS instance and saves it as \"bucket-list.xml\"
- #### Parses the .xml and saves the buckets\' names as \"buckets.txt\"
- #### Retrieves a list of all the objects in each bucket and saves them as \"$bucket-name-objects.xml\"
- #### Parses the .xml lists, retrieves only the name of objects that are archived and the last modified date is more recent that the specified in the .conf file
- #### Lastly, it restores those objects
## How to use:
- #### Provide, in the same directory, a script.conf file like this:
APIKEY=\"w0w-mUch-$ecR&t\"<br/>
CRN=\"some-numbers-and-letters\"<br/>
COS_ENDPOINT=\"s3.us-south.cloud-object-storage.appdomain.cloud\"<br/>
DATE=\"YYYY-MM-DD\"<br/>
DAYS=\"\<integer\>\"<br/>
TIER=(\"Bulk\"|\"Accelerated\")<br/>
- #### Run final-script.sh
