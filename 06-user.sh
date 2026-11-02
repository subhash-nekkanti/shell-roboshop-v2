#!/bin/bash
app_name="user"
source ./common.sh

root_check

app_setup
nodejs_setup
systemd_setup

restart
total_time_taken


