export PATH=/cygdrive/c/tools/cygwin/bin:$PATH

wget -q -O OpenJDK8_x64_Windows.zip "https://api.adoptopenjdk.net/v2/binary/releases/openjdk8?openjdk_impl=hotspot&os=windows&arch=x64&release=latest&type=jdk"
wget -q -O freetype.zip https://github.com/ubawurinna/freetype-windows-binaries/releases/download/v2.9.1/freetype-2.9.1.zip

JDK_BOOT_DIR="$PWD/$(unzip -Z1 OpenJDK8_x64_Windows.zip | grep 'bin/javac'  | tr '/' '\n' | tail -3 | head -1)"
unzip -q OpenJDK8_x64_Windows.zip
mkdir -p openjdk-build/freetype
mv freetype.zip openjdk-build/freetype/
$(cd openjdk-build/freetype/; unzip -q freetype.zip)

# unset cygwin's gcc preconfigured
unset -v CC
unset -v CXX

FREETYPE_DIR="$PWD/openjdk-build/freetype"
export TOOLCHAIN_VERSION="2013"
unset VS120COMNTOOLS
unset VS110COMNTOOLS

cd ./openjdk-build
export LOG=info
export LANG=C
export JAVA_HOME=$JDK_BOOT_DIR

./makejdk-any-platform.sh --branch "${SOURCE_JDK_BRANCH}" --tag "${SOURCE_JDK_TAG}" --jdk-boot-dir "${JDK_BOOT_DIR}" --build-variant dcevm --hswap-agent-download-url ${HSWAP_AGENT_DOWNLOAD_URL} --check-fingerprint false --configure-args "--with-toolchain-type microsoft --with-toolchain-version 2013 --with-freetype-include=${FREETYPE_DIR}/include --with-freetype-lib=${FREETYPE_DIR}/win64 --disable-ccache" --target-file-name java8-openjdk-dcevm-${TRAVIS_OS_NAME}.zip --version jdk8u --update-version 232 --build-number b01 jdk8u
