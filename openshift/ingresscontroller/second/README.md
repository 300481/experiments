# How to setup a second IngressController

No warranty, it's all fun! ;-)

This is done on the CRC Code Ready Containers / OpenShift Local.

```bash
user@host:~$ oc version
Client Version: 4.17.14
Kustomize Version: v5.0.4-0.20230601165947-6ce0bf390ce3
Server Version: 4.17.14
Kubernetes Version: v1.30.7
```

## 1. Install the MetalLB Operator

## 2. Apply the yaml files in this order

```bash
# MetalLB Configuration
oc apply -f ipaddresspool.yaml
oc apply -f l2advertisement.yaml

# Create an example project with a pod and a service
oc apply -f project.yaml
oc apply -f example-pod.yaml
oc apply -f service.yaml

# Create a second IngressController
oc apply -f ingresscontroller.yaml

# Create a route
oc apply -f route.yaml
```

## 3. Check the IngressController service External IP

```bash
user@host:~$ oc -n openshift-ingress get svc router-example
NAME             TYPE           CLUSTER-IP     EXTERNAL-IP       PORT(S)                      AGE
router-example   LoadBalancer   10.217.4.184   192.168.127.100   80:31544/TCP,443:31255/TCP   30m
```

## 4. curl the route (via the debug pod on the SNO node)
```bash
sh-5.1# curl --header 'Host: test.example.com' http://192.168.127.100/ -I
HTTP/1.1 403 Forbidden
date: Fri, 14 Mar 2025 13:05:08 GMT
server: Apache/2.4.37 (Red Hat Enterprise Linux) OpenSSL/1.1.1k
last-modified: Mon, 12 Jul 2021 19:36:32 GMT
etag: "133f-5c6f23d09f000"
accept-ranges: bytes
content-length: 4927
content-type: text/html; charset=UTF-8
set-cookie: 432a11f0f9b7ef5dcdadc2b1cbd1d20b=4b4399ed4896e8e2a437a2f9a0267a39; path=/; HttpOnly
```

## 5. check the logs of the example pod
```bash
user@host:~$ oc -n example logs example --tail=1
10.217.0.249 - - [14/Mar/2025:13:05:08 +0000] "HEAD / HTTP/1.1" 403 - "-" "curl/7.76.1"
```
