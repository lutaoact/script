#!/bin/bash

for i in 2017-12-22-101445 2018-01-04-181355 2018-02-09-111742 2018-02-23-103140 2018-03-29-124552 2018-04-18-153844 2018-06-04-164351 2018-08-07-143413 2018-08-26-110250 2018-10-11-112643 2019-01-23-113905 2019-03-06-173757 2019-04-11-120009 2019-04-11-134453 2019-04-11-135546 2019-04-11-135758 2019-04-11-142017; do
  echo $(date) delete $i start
  sudo tmutil delete /Volumes/TT/Backups.backupdb/tao.lu01/$i
  echo $(date) delete $i done
  sleep 3
done

for i in 2018-06-04-164351; do
  echo $(date) delete $i start
  sudo tmutil delete /Volumes/TT/Backups.backupdb/tao.lu01/$i
  echo $(date) delete $i done
  sleep 3
done

sudo tmutil delete /Volumes/TT/Backups.backupdb/tao.lu01/2018-08-26-110250
sudo tmutil delete /Volumes/TT/Backups.backupdb/tao.lu01/2018-08-07-143413
