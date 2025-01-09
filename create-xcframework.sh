#!/bin/bash

# Stop script on errors
set -e

# Define paths
FRAMEWORK_NAME="Mediasoup"
PROJECT_PATH="./Mediasoup.xcodeproj"
SCHEME_NAME="Mediasoup"
OUTPUT_DIR="./bin"
BUILD_DIR="./build/xcframework"

# Clean previous builds
rm -rf "${BUILD_DIR}"
mkdir -p "${BUILD_DIR}"
rm -rf "${OUTPUT_DIR}/${FRAMEWORK_NAME}.xcframework"

# Build for iOS devices
xcodebuild archive \
    -project "${PROJECT_PATH}" \
    -scheme "${SCHEME_NAME}" \
    -configuration Release \
    -destination "generic/platform=iOS" \
    -archivePath "${BUILD_DIR}/ios.xcarchive" \
    SKIP_INSTALL=NO \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES

# Build for iOS Simulator
xcodebuild archive \
    -project "${PROJECT_PATH}" \
    -scheme "${SCHEME_NAME}" \
    -configuration Release \
    -destination "generic/platform=iOS Simulator" \
    -archivePath "${BUILD_DIR}/ios-simulator.xcarchive" \
    SKIP_INSTALL=NO \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES

# Create XCFramework
xcodebuild -create-xcframework \
    -framework "${BUILD_DIR}/ios.xcarchive/Products/Library/Frameworks/${FRAMEWORK_NAME}.framework" \
    -framework "${BUILD_DIR}/ios-simulator.xcarchive/Products/Library/Frameworks/${FRAMEWORK_NAME}.framework" \
    -output "${OUTPUT_DIR}/${FRAMEWORK_NAME}.xcframework"

# Clean up build directory
rm -rf "${BUILD_DIR}"

echo "Successfully created ${FRAMEWORK_NAME}.xcframework in ${OUTPUT_DIR}" 