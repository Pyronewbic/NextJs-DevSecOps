#!/bin/bash
set -euo pipefail
DEPLOY_NAME=$1
NAMESPACE=$2

podRunningStatus(){
    count=$(kubectl get deploy $DEPLOY_NAME -n $NAMESPACE -o jsonpath="{.spec.replicas}")
    echo "Number of replicas of application = $count"
    i=1

    for (( i=1; i <= $count; i++ )) do
        podName=`kubectl get po -n $NAMESPACE | grep $DEPLOY_NAME | awk NR==$i{'print $1'}`
        echo "$i pod name is $podName"
        sleep 3
        podStatus=`kubectl get po $podName -n $NAMESPACE | grep $podName | cut -d ' ' -f 9`
        if [ "$podStatus" == "Running" ]; then
            echo "$podName status is $podStatus"
            echo "Checking if the Pod(s) are running without Restarts"
            restartNumberCheck1=$(kubectl get po $podName -n $NAMESPACE | grep $podName | cut -d ' ' -f 12)
            sleep 3
            if [ "$restartNumberCheck1" -gt "5" ]; then
                echo "Pod is restarting - Check it out"
                break
            else
                echo "$podName is Running fine without any restarts"
            fi
        else
            echo "$podName has error'd out - Check it out"
            exit 1
        fi
    done
}

echo "##################################################################"
echo "################# Pod Running Status #############################"
echo "##################################################################"
podRunningStatus