#!/bin/bash
set -e

# Setup gazebo environment
source "/usr/share/gazebo/setup.sh"
exec "$@"
