# test-asset-script

Sample script test asset for CONS3RT.

To use this sample:

1. Zip up the content of this directory
1. From the main menu, click *Tests*
1. Use [these instructions](https://kb.cons3rt.com/kb/assets/importing-your-asset-zip-file)
to import the asset zip file.
1. Add it to a deployment using 
[these instructions](https://kb.cons3rt.com/kb/deployments/creating-a-deployment).
1. Skip to step 2 and add this test asset
1. If you want the test to fail, set `testEndState=fail`
under custom properties, otherwise the test will pass
1. Launch your deployment, and download the results
under the *Results* tab when complete!

## Download Test Results

1. On the Run page click "Test Results"
1. Exand the set of test results to download
1. Click either the zip, which contains the contents of the REPORT_DIRECTORY or
click an individual file to download test results
1. Try clicking the *Re-Test* button on your run to get
a new set of results

Take a look at the `run_ms.sh` script in the scripts
directory to see how this works!

## Customize for your own use

To customize this asset for your own use edit the 
`run_me.sh` script, or add your own custom script to 
the scripts directory.  Then edit this file:

`script-config.properties`

Set the `executable` property to the file name 
of the script in the `scripts` directory that 
you would like to run.

Here are some helpful tips:

* You may have multiple scripts in the 
scripts directory, specify the one you would like 
executed first.
* Use a shell script as the primary script, 
but additional scripts can be other types.
* The scripts are executed on the Red Hat 6 elastic 
test tool host. 

## Asset directories

Use these environment variables to access files in the test asset:

* `MEDIA_DIRECTORY`: Path to the media directory in the test asset 
* `SCRIPTS_DIRECTORY`: Path to the scripts directory in the test asset

## Deployment properties

Use the `DEPLOYMENT_PROPERTIES_FILE` environment variable to access 
deployment properties such as IP address data, deployment 
data, user data, and custom properties to feed into your 
test script.

## Generate Downloadable Test Results

Use these environment variable to generate downloadable test results:

* `REPORT_DIRECTORY`: Path to the report directory
* `LOG_DIRECTORY`: Path to REPORT_DIRECTORY\log

Any files placed in these directories will be available to download
from the deployment run page.
