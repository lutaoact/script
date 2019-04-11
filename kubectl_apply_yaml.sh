for i in app-controller authgate authgate-tcp cluster-role compass gragate ingress k8s-dashboard kirk-apiserver kubegate logservice onetimeurl-controller promgate secret tlbop; do
  (cd $i && k apply -f .)
done
