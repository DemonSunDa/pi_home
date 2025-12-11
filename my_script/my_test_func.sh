#!/bin/bash

# =============================================================================
# Test functions
# =============================================================================

function my_test_func1 {
    if [ -n "$2" ]; then
        testmode="t"
    else
        testmode=""
    fi

    echo "Test function called with arg: $1 and testmode: $testmode"
}
