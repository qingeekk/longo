#!/bin/bash

SERVER="longo"
BASE_DIR=$PWD
INTERVAL=2

# 命令行参数, 需要手动指定
ARGS=""

function start()
{
  if [ "`pgrep $SERVER -u $UID`" != "" ];then
    echo "$SERVER already running"
    exit 1
  fi

  nohup $BASE_DIR/$SERVER $ARGS server &>/dev/null &

  echo "start waiting..." && sleep $INTERVAL

  # check status
  if [ "`pgrep $SERVER -u $UID`" == "" ];then
    echo "$SERVER start failed"
    exit 1
  fi
}

function status()
{
    if [ "`pgrep $SERVER -u $UID`" != "" ];then
      echo "$SERVER is running"
    else
      echo "$SERVER is not running"
    fi
}

function stop()
{
  if [ "`pgrep $SERVER -u $UID`" != "" ];then
    kill -9 `pgrep $SERVER -u $UID`
  fi

  echo "stop waiting..." && sleep $INTERVAL

  if [ "`pgrep $SERVER -u $UID`" != "" ];then
    echo "$SERVER stop failed"
    exit 1
  fi
}

case "$1" in
  'start')
  start
  ;;
  'stop')
  stop
  ;;
  'status')
  status
  ;;
  'restart')
  stop && start
  ;;
  *)
  echo "usage: $0 {start|stop|status|restart}"
  exit 1
  ;;
esac