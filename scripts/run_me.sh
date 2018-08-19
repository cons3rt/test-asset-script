#!/bin/bash

# Set log commands
logTag="sample-test-asset"
logInfo="logger -i -s -p local3.info -t ${logTag} [INFO] "
logWarn="logger -i -s -p local3.warning -t ${logTag} [WARNING] "
logErr="logger -i -s -p local3.err -t ${logTag} [ERROR] "

# Get the current timestamp and append to logfile name
TIMESTAMP=$(date "+%Y-%m-%d-%H%M")
LOGFILE="/tmp/cons3rt-test-script-${logTag}-${TIMESTAMP}.log"

function test() {

	if [ -z ${TMA_HOME} ]
	then
		${logWarn} "TMA_HOME not set"
	else
		${logInfo} "TMA_HOME: ${TMA_HOME}"
	fi

	if [ -z ${ASSET_DIR} ]
	then
		${logWarn} "ASSET_DIR not set"
	else
		${logInfo} "ASSET_DIR: ${ASSET_DIR}"
	fi

	if [ -z ${DEPLOYMENT_HOME} ]
	then
		${logWarn} "DEPLOYMENT_HOME not set.  Attempting to set DEPLOYMENT_HOME ..."
	else
		locatedPropFiles=`find / -name deployment.properties`
		${logInfo} "Found deployment.properties files here: ${locatedPropFiles}"
		DEPLOYMENT_DIR=`ls /opt/testmanageragent/run | grep Deployment`
		DEPLOYMENT_HOME=/opt/testmanageragent/run/${DEPLOYMENT_DIR}
		${logInfo} "Trying DEPLOYMENT_HOME: ${DEPLOYMENT_HOME}"
	fi

	if [ ! -d ${DEPLOYMENT_HOME} ]
	then
		${logErr} "DEPLOYMENT_HOME is set to - ${DEPLOYMENT_HOME} - and is not a valid directory.  Exiting with code 3 ..."
		exit 3
	else
		${logInfo} "DEPLOYMENT_HOME is a valid directory"
	fi

	propFile="${DEPLOYMENT_HOME}/deployment.properties"

	if [ ! -f ${propFile} ]
	then
		${logErr} "The properties file ${propFile} is not a valid file.  Exiting with code 4 ..."
		exit 4
	else
		${logInfo} "propFile: ${propFile}"
	fi

	${logInfo} "Grabbing values from ${propFile} ..."
	RUNID=`grep cons3rt.deploymentRun.id= ${propFile} | awk -F = '{ print $2 }'`
	TESTBUNDLEID=`grep cons3rt.deployment.testbundle.1.id ${propFile} | awk -F = '{ print $2 }'`
	TESTASSETID=`grep cons3rt.deployment.testbundle.1.testAsset.id ${propFile} | awk -F = '{ print $2 }'`

	${logInfo} "RUNID: ${RUNID}"
	${logInfo} "TESTBUNDLEID: ${TESTBUNDLEID}"
	${logInfo} "TESTASSETID: ${TESTASSETID}"

	# set up output files

	BASEDIR="/opt/testmanageragent/run/Deployment${DEPLOYID}/run/${RUNID}/"
	${logInfo} "BASEDIR: ${BASEDIR}"

	${logInfo} "Printing various ENV variables ..."
	${logInfo} "PATH: ${PATH}"
	${logInfo} "PWD: ${PWD}"
	${logInfo} "HOME: ${HOME}"

	${logInfo} "Printing /root/.bashrc ..."
	cat /root/.bashrc

	CURRENT_DIR=`pwd`
	${logInfo} "Current Directory is ${CURRENT_DIR}"


	testEndState=`grep testEndState= ${propFile} | awk -F = '{ print $2 }'`

	if [ -z "${testEndState}" ]
	then
		${logErr} "Deployment property not set - testEndState - this needs to be set to pass for successful test execution. Exiting with code 1 ..."
		exit 2
	else
		echo "Found Deployment property: testEndState = ${testEndState}"
	fi

	if [ "${testEndState}" == "pass" ]
	then
		${logInfo} "Expected end State was expected to pass. Exiting with code 0 ..."
		exit 0
	else
		${logInfo} "Expected end State was expected to fail: ${testEndState}. Exiting with code 2 ..."
		exit 1
	fi
	exit

}

test 2>&1 | tee ${LOGFILE}

chmod 644 ${LOGFILE}

exit 0
