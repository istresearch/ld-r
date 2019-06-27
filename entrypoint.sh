#!/bin/bash
cat /ld-r/configs/vars.js.template | envsubst > /ld-r/configs/vars.js

npm run build
