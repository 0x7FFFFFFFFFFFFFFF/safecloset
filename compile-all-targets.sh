# WARNING: This script is NOT meant for normal installation, it's dedicated
# to the compilation of all supported targets, from a linux machine.
# This is a long process and it involves specialized toolchains.
# For usual compilation do
#     cargo build --release

H1="\n\e[30;104;1m\e[2K\n\e[A" # style first header
H2="\n\e[30;104m\e[1K\n\e[A" # style second header
EH="\e[00m\n\e[2K" # end header

version=$(sed 's/version = "\([0-9.]\{1,\}\(-[a-z]\+\)\?\)"/\1/;t;d' Cargo.toml | head -1)
echo -e "${H1}Compilation of all targets for safecloset $version${EH}"
 
# clean previous build
rm -rf build
mkdir build
echo "   build cleaned"

# build the linux version
echo -e "${H2}Compiling the linux version${EH}"
cargo build --release --features clipboard
strip target/release/safecloset
mkdir build/x86_64-linux/
cp target/release/safecloset build/x86_64-linux/

# build the windows version
# use cargo cross
echo -e "${H2}Compiling the Windows version${EH}"
cross build --target x86_64-pc-windows-gnu --release --features clipboard
mkdir build/x86_64-pc-windows-gnu
cp target/x86_64-pc-windows-gnu/release/safecloset.exe build/x86_64-pc-windows-gnu/

# # build the Raspberry version
# # use cargo cross
# echo -e "${H2}Compiling the Raspberry version${EH}"
# cross build --target armv7-unknown-linux-gnueabihf --release --no-default-features
# mkdir build/armv7-unknown-linux-gnueabihf
# cp target/armv7-unknown-linux-gnueabihf/release/safecloset build/armv7-unknown-linux-gnueabihf/

# build the Android version
# use cargo cross
echo -e "${H2}Compiling the Android version${EH}"
cross build --target aarch64-linux-android --release --features clipboard
mkdir build/aarch64-linux-android
cp target/aarch64-linux-android/release/safecloset build/aarch64-linux-android/

# build a musl version
echo -e "${H2}Compiling the MUSL version${EH}"
cross build --release --target x86_64-unknown-linux-musl --no-default-features
mkdir build/x86_64-unknown-linux-musl
cp target/x86_64-unknown-linux-musl/release/safecloset build/x86_64-unknown-linux-musl
