Coverage threading bug
======================

Filed here: [bitbucket.org](https://bitbucket.org/ned/coveragepy/issues/583/fatal-python-error-with-threaded-unit-test)

EDIT: appears to be fixed upstream. I've filed a
[bug against Fedora](https://bugzilla.redhat.com/show_bug.cgi?id=1452339)
to update.

While working on unit tests for py3 support in [Koji](https://pagure.io/koji),
I encountered a strange failure running nosetests-3.

The tests themselves would run fine, and the coverage information was
displayed. However, the command would exit with an error like:

```
Fatal Python error: deallocating None

Current thread 0x00007f85638a0700 (most recent call first):
Aborted (core dumped)
```

I've reduced the issue down to the contents of this repo. It seems that the
use of threading in the test case seems to be breaking something in coverage.

To replicate: run `run.sh` in the checkout

Note: sometimes you might need to run it more than once to hit the bug.

Things that avoid the issue:

    * removing `/usr/lib/*` from omit in `.coveragerc`
    * adding `timid=true` in `.coveragerc`
    * running with python2 instead

The error is happening at exit. If you trace the run with pdb, there are no
errors until you exit python itself. See: `run_pdb.sh`

If you run through gdb, you get the following backtrace.

```
0x00007ffff6c50765 in __GI_raise (sig=sig@entry=6) at ../sysdeps/unix/sysv/linux/raise.c:54
54	  return INLINE_SYSCALL (tgkill, 3, pid, selftid, sig);
(gdb) bt
#0  0x00007ffff6c50765 in __GI_raise (sig=sig@entry=6) at ../sysdeps/unix/sysv/linux/raise.c:54
#1  0x00007ffff6c5236a in __GI_abort () at abort.c:89
#2  0x00007ffff7a4e81f in Py_FatalError () from /lib64/libpython3.5m.so.1.0
#3  0x00007ffff79aacb7 in free_keys_object () from /lib64/libpython3.5m.so.1.0
#4  0x00007ffff79ae219 in dict_tp_clear () from /lib64/libpython3.5m.so.1.0
#5  0x00007ffff7a6ad42 in collect () from /lib64/libpython3.5m.so.1.0
#6  0x00007ffff7a6ba61 in _PyGC_CollectNoFail () from /lib64/libpython3.5m.so.1.0
#7  0x00007ffff7a43d78 in PyImport_Cleanup () from /lib64/libpython3.5m.so.1.0
#8  0x00007ffff7a4e5a4 in Py_Finalize () from /lib64/libpython3.5m.so.1.0
#9  0x00007ffff7a4f258 in Py_Exit () from /lib64/libpython3.5m.so.1.0
#10 0x00007ffff7a51f78 in handle_system_exit.part () from /lib64/libpython3.5m.so.1.0
#11 0x00007ffff7a5235d in PyErr_PrintEx () from /lib64/libpython3.5m.so.1.0
#12 0x00007ffff7a6905d in RunModule () from /lib64/libpython3.5m.so.1.0
#13 0x00007ffff7a69761 in Py_Main () from /lib64/libpython3.5m.so.1.0
#14 0x0000555555554b70 in main ()
```


