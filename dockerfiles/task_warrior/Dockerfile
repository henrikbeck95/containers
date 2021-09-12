FROM docker.io/alpine:3.14
MAINTAINER Henrik Beck <henrikbeck95@gmail.com>

RUN set -x && \
	apk add --no-cache task && \
	echo -e "# [Created by task 2.5.3 9/11/2021 23:30:05]\n# Taskwarrior program configuration file.\n# For more documentation, see http://taskwarrior.org or try 'man task', 'man task-color',\n# 'man task-sync' or 'man taskrc'\n\n# Here is an example of entries that use the default, override and blank values\n#   variable=foo   -- By specifying a value, this overrides the default\n#   variable=      -- By specifying no value, this means no default\n#   #variable=foo  -- By commenting out the line, or deleting it, this uses the default\n\n# Use the command 'task show' to see all defaults and overrides\n\n# Files\ndata.location=~/.task\n\n# Color theme (uncomment one to use)\n#include /usr/share/doc/task/rc/light-16.theme\n#include /usr/share/doc/task/rc/light-256.theme\n#include /usr/share/doc/task/rc/dark-16.theme\n#include /usr/share/doc/task/rc/dark-256.theme\n#include /usr/share/doc/task/rc/dark-red-256.theme\n#include /usr/share/doc/task/rc/dark-green-256.theme\n#include /usr/share/doc/task/rc/dark-blue-256.theme\n#include /usr/share/doc/task/rc/dark-violets-256.theme\n#include /usr/share/doc/task/rc/dark-yellow-green.theme\n#include /usr/share/doc/task/rc/dark-gray-256.theme\n#include /usr/share/doc/task/rc/dark-gray-blue-256.theme\n#include /usr/share/doc/task/rc/solarized-dark-256.theme\n#include /usr/share/doc/task/rc/solarized-light-256.theme\n#include /usr/share/doc/task/rc/no-color.theme" > /root/.taskrc

EXPOSE 5678
