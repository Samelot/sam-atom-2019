#!/bin/bash

CORONA_PATH='/Applications/CoronaSDK/Corona Simulator.app/Contents/MacOS/Corona Simulator'

exec "$CORONA_PATH" -project . -skin iPhone -no-console YES | sed -E 's/[0-9]{2}:[0-9]{2}:[0-9]{2}//'


