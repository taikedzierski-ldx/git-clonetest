#!/usr/bin/env python3
# ^--- update this shebang to "#!py -3" on Windows

""" Module to produce a plotted graph of data points.

Assumes first and second columns of CSV data are timestamps in the format

    YYYY/MM/DD hh:mm:ss

"""

import sys
from datetime import datetime

from matplotlib import pyplot

# Timestamp as printed by `date '+%F %T`
DATEFORMAT = '%Y-%m-%d %H:%M:%S'

# Produce a label every 10 instances
LABEL_SPACING = 10


def main():
    assert sys.argv[1:], "No files supplied"
    for pf in sys.argv[1:]:
        durations, labels, ticks = extract_points(pf)
        plot_points(pf, durations, labels, ticks)


def get_date(timestamp):
    return datetime.strptime(timestamp, DATEFORMAT)


def extract_points(csv_file):
    durations = []

    labels = []

    # Tracking data point count, for label spacing
    count = 0

    print("Plotting "+csv_file)

    with open(csv_file) as fh:
        for line in fh:
            line = line.strip()

            # Start time and end time in the first two columns
            start, end, *remainder = line.split(",")

            start_label = start
            start = get_date(start)
            end = get_date(end)

            duration = end-start
            durations.append(duration.seconds/60.0)

            if count % LABEL_SPACING == 0:
                labels.append(start_label)
            count += 1

    ticks = list(range(0, count, LABEL_SPACING))

    return durations, labels, ticks


def plot_points(csv_file, durations, labels, ticks):
    pyplot.plot(durations)
    # Spaced labels on X-axis. `yticks` exists for y axis
    pyplot.xticks(ticks=ticks, labels=labels, rotation=30)
    pyplot.title("Git Clone Duration (minutes, decimal)\n"+csv_file)
    # Ensure labels don't fall of bottom of rendered image:
    pyplot.tight_layout()

    outfile_name = csv_file+".png"
    print(f"Saving {outfile_name} ...")
    pyplot.savefig(outfile_name, dpi=150)

    pyplot.clf() # Clear the figure


if __name__ == "__main__":
    main()
