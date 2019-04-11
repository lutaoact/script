#!/usr/sbin/dtrace -s

fbt::bdev_strategy:entry
{
   trace(execname);
   trace(" is initiating a disk I/O\n");
}
