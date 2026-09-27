#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."

# 保留锁定依赖，并在编译前应用必要的兼容修复。
xcodebuild -resolvePackageDependencies \
    -project Ice.xcodeproj -scheme Ice \
    -clonedSourcePackagesDirPath build/SourcePackages
python3 scripts/prepare_dependencies.py build/SourcePackages
# 本地临时签名没有团队 ID，不启用依赖团队签名的强化运行时。
xcodebuild -project Ice.xcodeproj -scheme Ice -configuration Release \
    -derivedDataPath build/DerivedData \
    -clonedSourcePackagesDirPath build/SourcePackages \
    -disableAutomaticPackageResolution \
    CODE_SIGN_IDENTITY=- CODE_SIGN_STYLE=Manual ENABLE_HARDENED_RUNTIME=NO build
