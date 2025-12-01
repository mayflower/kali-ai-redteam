#!/bin/bash

# Pass through API key if provided
if [ -n "$ANTHROPIC_API_KEY" ]; then
    export ANTHROPIC_API_KEY
fi

exec "$@"
