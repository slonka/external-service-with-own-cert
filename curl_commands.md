run curl pod outside the mesh:

```bash
kubectl run mycurlpod --namespace=default --image=curlimages/curl -i --tty -- sh
```

copy:
- `certs/echo-2-signed-by-root-ca-1.crt` as `/tmp/client.crt`
- `certs/privkey-echo-2.key` as `/tmp/client.key`
- `certs/root-ca-1.crt` as `/tmp/ca.crt`

issue curl

```
curl --cert /tmp/client.crt --key /tmp/client.key --cacert /tmp/ca.crt https://echo-server.default.svc.cluster.local:8443
```

it should pass and you should get a response with 200.

now run curl inside the mesh:

```bash
kubectl run mycurlpod --namespace=es-test --image=curlimages/curl -i --tty -- sh
```

and issue:

```bash
curl echo-server.mesh:80
```

and it works