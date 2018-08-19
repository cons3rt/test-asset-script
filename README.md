# test-asset-script

Sample script test asset for CONS3RT.

To use this sample:

1. Zip up the content of this directory
1. From the main menu, click *Tests*
1. Use [these instruction](https://kb.cons3rt.com/kb/assets/importing-your-asset-zip-file)
to import the asset zip file.
1. Add it to a deployment using 
[these instructions](https://kb.cons3rt.com/kb/deployments/creating-a-deployment).
1. Skip to step 2 and add this test asset
1. If you want the test to pass, set `testEndState=pass`
under custom properties, otherwise the test will fail.
1. Launch your deployment, and download the results
under the *Results* tab when complete!
1. Try, clicking the *Re-Test* button on your run to get
a new set of results.

Take a look at the `run_me.sh` script in the scripts
directory to see how this works!

## Customize for your own use

To customize this asset for your own use edit the 
run_me.sh script, or add your own custom script to 
the scripts directory.  Then edit this file:

`script-config.properties`

Set the `executable` property to the file name 
of the script in the `scripts` directory that 
you would like to run.

> You may have multiple scripts in the 
scripts directory, specify the one you would like 
executed first.

> Use a shell script as the primary script, 
but additional scripts can be other types.

> The scripts are executed on the Red Hat 6 elastic 
test tool host. 


