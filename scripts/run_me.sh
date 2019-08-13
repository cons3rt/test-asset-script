#!/bin/bash
#
# run_me.sh
#
# Environment Variables to use in your script:
#
# Directories in the test asset:
# - MEDIA_DIRECTORY: Path to the media directory in the test asset
# - SCRIPTS_DIRECTORY: Path to the scripts directory in the test asset
#
# To generate test results:
# - REPORT_DIRECTORY: Path to the report directory, contents will be downloadable as test results
# - LOG_DIRECTORY: Path to REPORT_DIRECTORY\log
#
# Deployment properties
# - DEPLOYMENT_PROPERTIES_FILE: Path to the deployment-properties.ps1 file.  Use this to read IP
# address information or custom properties for your test.
#

# Source the environment
if [ -f /etc/bashrc ] ; then
    . /etc/bashrc
fi
if [ -f /etc/profile ] ; then
    . /etc/profile
fi

######################### GLOBAL VARIABLES #########################

# Establish a log file and log tag
logTag="test-script"
logFile="${LOG_DIRECTORY}/${logTag}-$(date "+%Y%m%d-%H%M%S").log"

# Default test end state
testEndStateValue="pass"

######################## UTILITY FUNCTIONS #########################

# Logging functions
function timestamp() { date "+%F %T"; }
function logInfo() { echo -e "$(timestamp) ${logTag} [INFO]: ${1}" >> ${logFile}; }
function logWarn() { echo -e "$(timestamp) ${logTag} [WARN]: ${1}" >> ${logFile}; }
function logErr() { echo -e "$(timestamp) ${logTag} [ERROR]: ${1}" >> ${logFile}; }

function get_test_end_state() {
    logInfo "Determining the test end state from deployment properties..."

    # Ensure the deployment properties file environment variable exists
    if [ -z "${DEPLOYMENT_PROPERTIES_FILE}" ]; then
        logErr "Environment variable not found: DEPLOYMENT_PROPERTIES_FILE"
        return 1
    fi

    # Ensure the deployment properties file exists
    if [ ! -f ${DEPLOYMENT_PROPERTIES_FILE} ]; then
        logErr "Deployment properties file not found: ${DEPLOYMENT_PROPERTIES_FILE}"
        return 2
    fi

    # Attempt to find the testEndState prop
    testEndState=$(cat ${DEPLOYMENT_PROPERTIES_FILE} | grep "testEndState" | awk -F = '{print $2}')

    # Use the default if the custom prop is not found
    if [ -z "${testEndState}" ]; then
        logInfo "testEndState custom property not found, using default: ${testEndStateValue}"
        return 0
    fi

    # Use the custom property value
    testEndStateValue="${testEndState}"
    logInfo "Found custom property for testEndState: ${testEndStateValue}"
    return 0
}

function main() {
    logInfo "Beginning ${logTag} script..."
    get_test_end_state
    if [ $? -ne 0 ]; then logErr "There was a problem determining testEndState"; return 1; fi

    logInfo "Using testEndState = ${testEndStateValue}"

    # Print test warning and a test error
    logWarn "This is a test warning"
    logErr "This is a test error"

    # Print the media and scripts directories
    logInfo "Test asset media directory: ${MEDIA_DIRECTORY}"
    logInfo "Test asset scripts directory: ${SCRIPTS_DIRECTORY}"

    # Print locations of the report directoiries
    logInfo "Attempting to print desired Environment vars..."
    logInfo "Results Dir: ${REPORT_DIRECTORY}"
    logInfo "Log Dir: ${LOG_DIRECTORY}"

    # Add some test results
    logInfo "Adding file to results dir..."
    echo "HELLO WORLD TEST RESULTS!!" > ${REPORT_DIRECTORY}/testresults.txt

    # Add a test log file
    logInfo "Adding file to log dir..."
    echo "HELLO WORLD TEST LOG!!" > ${LOG_DIRECTORY}/testlog.log

    # Add enviroinment variables to the test results
    logInfo "Adding an environment.log file to the test results..."
    env > ${LOG_DIRECTORY}/environment.log

    logInfo "Note, this log file should be located in the lgo directory"

    # Exiting based on the desired test end state
    if [[ ${testEndStateValue} == "fail" ]]; then
        logErr "The tester requested a test error! So, here you go!"
        return 2
    fi
    logInfo "The tester requested a test pass!  Yay!  We passed!"
    return 0
}

##################### MAIN SCRIPT EXECUTION ########################

# Set up the log file
touch ${logFile}
chmod 644 ${logFile}

main
result=$?
cat ${logFile}

logInfo "Exiting with code ${result} ..."
exit ${result}
