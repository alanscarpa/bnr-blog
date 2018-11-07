#!/bin/sh

ps -ef | grep wiremock | grep -v grep | awk '{print $2}' | xargs kill
