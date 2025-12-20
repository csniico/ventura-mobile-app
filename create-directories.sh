#!/bin/bash

# Check if a feature name was provided
if [ -z "$1" ]; then
  echo "Usage: ./create_feature.sh <feature_name>"
  exit 1
fi

FEATURE_NAME=$1

# Define directories
DIRS=(
  "lib/features/$FEATURE_NAME/data/data_sources/local/abstract_interfaces"
  "lib/features/$FEATURE_NAME/data/data_sources/local/implementations"
  "lib/features/$FEATURE_NAME/data/data_sources/remote/abstract_interfaces"
  "lib/features/$FEATURE_NAME/data/data_sources/remote/implementations"
  "lib/features/$FEATURE_NAME/data/models"
  "lib/features/$FEATURE_NAME/data/repositories"
  "lib/features/$FEATURE_NAME/domain/entities"
  "lib/features/$FEATURE_NAME/domain/repositories"
  "lib/features/$FEATURE_NAME/domain/use_cases"
  "lib/features/$FEATURE_NAME/presentation/bloc"
  "lib/features/$FEATURE_NAME/presentation/cubit"
  "lib/features/$FEATURE_NAME/presentation/pages"
  "lib/features/$FEATURE_NAME/presentation/widgets"
)

# Create Directories
echo "Creating directory structure for feature: $FEATURE_NAME..."
for dir in "${DIRS[@]}"; do
  mkdir -p "$dir"
done

# Create placeholder files (Optional: Remove if you only want empty folders)
touch "lib/features/$FEATURE_NAME/domain/repositories/${FEATURE_NAME}_repository.dart"
touch "lib/features/$FEATURE_NAME/data/repositories/${FEATURE_NAME}_repository_impl.dart"

echo "Structure created successfully."