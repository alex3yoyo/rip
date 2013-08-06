#!/bin/bash

echo "Updateing gonewild users"
./gonewild/update.sh

echo "Updating instagram users"
./instagram/update.sh

echo "Done"

exit