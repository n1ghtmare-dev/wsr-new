#!/bin/bash
user=oleg
if grep $user /etc/passwd > /dev/null
then
echo "user: $user"
fi

