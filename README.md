# Network speed test via Git cloning

A simple set of tools to perform repeated cloning on a test unit machine to get timings of cloning a repo.

## Test unit

On the Windows unit you want to test from, install [Git SCM with Git Bash](https://git-scm.com) ; or, use a Linux unit.

Edit the config in `unit_scripts/LOOP_CONFIG.sh` to reflect your environment

In a Git Bash shell, run `unit_scripts/looping_clones.sh`

This will clone the specified repo every 10 minutes.

## Graphing

Extract the data using `unit_scripts/extract_clone_csv.sh DATAFILES ...` to produce CSV files

This will produce a Base64 tarball which you can optionally copy to another computer: copy the Base64 text, and on the other computer, run `bin/base64_unpack.sh`. Paste the data in, and end the input with Ctrl + D (in bash - probably different in CMD or PowerShell)

Execute `bin/draw_plot.py CSV_FILES ...` on the CSV files to produce plotted graphs. This requires matplotlib. You can add that by running `pip3 install -r requirements.txt`
