# Have rustup version trump homebrew version
RUSTUP_CARGO="$(rustup which cargo --toolchain stable)"
RUSTUP_TOOLCHAIN_DIR="$(dirname $RUSTUP_CARGO)"
export PATH="$RUSTUP_TOOLCHAIN_DIR:$PATH"
# Set default CC to Clang
export CC="clang"


