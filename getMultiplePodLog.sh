i=1
for pod in $(k get po | grep ke-authgate | awk '{print $1}'); do
    echo $i $pod
    k logs --tail 100000 $pod > authgate$i.log
    i=$((i+1))
done

i=1
for pod in $(k get po | grep ke-account | awk '{print $1}'); do
    echo $i $pod
    k logs --tail 100000 $pod > account$i.log
    i=$((i+1))
done

i=1
for pod in $(k get po | grep ke-kubegate | awk '{print $1}'); do
    echo $i $pod
    k logs --tail 100000 $pod > kubegate$i.log
    i=$((i+1))
done
