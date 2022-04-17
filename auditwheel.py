#!/usr/bin/env python
import sys
from auditwheel.policy import load_policies
from auditwheel.main import main

libmpi = [
    'libmpi.so.12',  # MPICH
    'libmpi.so.0',   # Open MPI v1.0
    'libmpi.so.1',   # Open MPI v1.6
    'libmpi.so.12',  # Open MPI v1.10
    'libmpi.so.20',  # Open MPI v2.0
    'libmpi.so.40',  # Open MPI v3.0
    'libmpi.so.80',  # Open MPI v5.0
]

for policy in load_policies():
    policy['lib_whitelist'].extend(libmpi)

if __name__ == "__main__":
    sys.exit(main())
