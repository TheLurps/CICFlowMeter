#!/bin/bash
set -e

# Require exactly two arguments
if [ "$#" -ne 2 ]; then
  echo "Usage: <pcap-file-or-dir> <output-dir>"
  exit 1
fi

PCAP_PATH="$1"
OUTPUT_DIR="$2"

# Validate input file/directory
if [ -f "$PCAP_PATH" ]; then
  echo "Input is a pcap file: $PCAP_PATH"
elif [ -d "$PCAP_PATH" ]; then
  echo "Input is a directory: $PCAP_PATH"
else
  echo "Error: '$PCAP_PATH' is not a valid file or directory"
  exit 1
fi

# Validate output directory
if [ ! -d "$OUTPUT_DIR" ]; then
  echo "Error: '$OUTPUT_DIR' is not an existing directory"
  exit 1
fi

# Execute the Java application
exec java -cp target/CICFlowMeterV3-0.0.4-SNAPSHOT.jar cic.cs.unb.ca.ifm.Cmd "$PCAP_PATH" "$OUTPUT_DIR"
