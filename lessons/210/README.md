# Node.js vs Golang: Performance Benchmark in Kubernetes

You can find tutorial [here](https://youtu.be/ZslbMp_T90k).

## Commands from the Tutorial

1. Create a instance in same vpc for postgres. Login and use postgrese_setup.sh script to install and setup postgres.
2. Update all places for postgres server ip.
3. Create and install promethues and grafana on kubernetes.
```bash
cd lessons/180/terraform
terraform plan
terraform apply
```
4. Expose grafana and promethues to check graphs.
```bash
kubectl port-forward svc/prometheus-operated 9090 -n monitoring
sudo kubectl port-forward svc/grafana 80 -n monitoring
```
5. Add promethues as Data source. URL is `http://prometheus-operated.monitoring.svc.cluster.local:9090`
6. Copy dashboard JSON and Apply JSON.
7. Deploy application `kubectl apply -R -f deploy`.
8. Deploy test-client applications now `kubectl apply -f 1-test`.
9. Expose grafana and promethues to check graphs.
```bash
kubectl port-forward -n monitoring svc/prometheus-grafana 3000:80  # admin/admin
kubectl port-forward -n monitoring svc/prometheus-kube-prometheus-prometheus 9090:9090
```


```bash
kubectl apply -R -f deploy
kubectl apply -f 1-test
kubectl apply -f 2-test
```