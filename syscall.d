#!/usr/sbin/dtrace -s

syscall:::entry
{
  trace(execname);
}
