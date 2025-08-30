#!/usr/bin/awk -f

BEGIN {
    size = ARGV[1]
    delete ARGV[1]  # Remove the argument so AWK doesn't treat it as a filename

    # Initialize array
    a[1] = 1
    a[2] = 1
    end = 3

    for (i = 1; end < size - 1; i++) {
        a[end] = a[i] + a[i + 1]
        a[end + 1] = a[i + 1]
        end += 2
    }

    # Print the array
    for (i = 1; i <= size; i++) {
        printf "%d ,", a[i]
    }
    print ""
}

