#!/bin/bash
source ./common.sh
app_name="payment"

root_check
app_setup
python_setup
systemd_setup

restart

total_time_taken


