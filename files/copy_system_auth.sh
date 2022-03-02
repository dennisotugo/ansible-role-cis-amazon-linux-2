#!/bin/bash
cd /etc/pam.d
mv system-auth system-auth-local
ln -s system-auth-local system-auth

