#!/usr/bin/env bash

function _print_virtualbox_dashboard() {
  NUM_VAGRANT_VMS=`VBoxManage list vms | egrep -e "_\d{10}" | wc -l`
  NUM_RUNNING_VAGRANT_VMS=`VBoxManage list runningvms | egrep -e "_\d{10}" | wc -l`

  echo You have ${NUM_RUNNING_VAGRANT_VMS} /${NUM_VAGRANT_VMS} vagrant launched virtualbox VMs running right now
}

function display_vagrant_bash_dash() {
  _print_virtualbox_dashboard
}

display_vagrant_bash_dash

