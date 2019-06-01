# TODO: abort the script if anything is in $NETWORK_DIRECTORY/blocks

UTXO_DOWNLOAD_LINK="http://utxosets.blob.core.windows.net/public/utxo-snapshot-bitcoin-testnet-1445586.tar"
# $BITCOIN_DATA_DIR defined in bashrc
NETWORK_DIRECTORY="$BITCOIN_DATA_DIR/testnet3"
TAR_NAME="$(basename $UTXO_DOWNLOAD_LINK)"
TAR_FILE="$BITCOIN_DATA_DIR/$TAR_NAME"

cd $BITCOIN_DATA_DIR
echo 'Working directory: "$BITCOIN_DATA_DIR"'

if [ ! -d $NETWORK_DIRECTORY ]; then
    echo "Creating testnet data dir"
    mkdir -p $NETWORK_DIRECTORY;
fi

if [ ! -e $TAR_FILE ]; then
    echo "Downloading $UTXO_DOWNLOAD_LINK to $TAR_FILE"
    wget "$UTXO_DOWNLOAD_LINK" -q --show-progress -O $TAR_FILE
else
    echo "Already downloaded $UTXO_DOWNLOAD_LINK"
fi

echo "cleaning network dir"
[ -d "$NETWORK_DIRECTORY/blocks" ] && rm -rf "$NETWORK_DIRECTORY/blocks"
[ -d "$NETWORK_DIRECTORY/chainstate" ] && rm -rf "$NETWORK_DIRECTORY/chainstate"
[ ! -d "$NETWORK_DIRECTORY" ] && mkdir "$NETWORK_DIRECTORY"

echo "Extracting..."
if ! tar -xf "$TAR_FILE" -C "$BITCOIN_DATA_DIR"; then
  echo "Failed extracting, did you turned bitcoin off? (btcpay-down.sh)"
  exit 1
fi

