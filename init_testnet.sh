KEY="mykey"
KEY2="mykey2"
CHAINID="pepe_555555-1"
MONIKER="mynode"
KEYRING="test"
KEYALGO="secp256k1"
LOGLEVEL="info"
pepe_HOME=~/.pepe
ALICE_MNEMONIC="ood banana romance audit female method staff soft resist upset cousin decorate hero gesture sing poet toddler connect decade speak dog scrap unfold spike"
BOB_MNEMONIC="slot wife this apology hire ship also express close day survey hood popular expect field client lady awesome symptom jealous detail street call couple"
# to trace evm
#TRACE="--trace"
TRACE=""

# validate dependencies are installed
command -v jq > /dev/null 2>&1 || { echo >&2 "jq not installed. More info: https://stedolan.github.io/jq/download/"; exit 1; }

# Reinstall daemon
rm -rf ~/.pepe*
make install

# Set client config
peped config keyring-backend $KEYRING
peped config chain-id $CHAINID

# if $KEY exists it should be deleted
echo $ALICE_MNEMONIC | peped keys add $KEY --recover --home ${pepe_HOME} --keyring-backend $KEYRING --algo $KEYALGO
echo $BOB_MNEMONIC | peped keys add $KEY2 --recover --home ${pepe_HOME} --keyring-backend $KEYRING --algo $KEYALGO

# Set moniker and chain-id for pepe (Moniker can be anything, chain-id must be an integer)
peped init $MONIKER --chain-id $CHAINID

# Change parameter token denominations to apepe
cat $HOME/.pepe/config/genesis.json | jq '.app_state["staking"]["params"]["bond_denom"]="apepe"' > $HOME/.pepe/config/tmp_genesis.json && mv $HOME/.pepe/config/tmp_genesis.json $HOME/.pepe/config/genesis.json
cat $HOME/.pepe/config/genesis.json | jq '.app_state["crisis"]["constant_fee"]["denom"]="apepe"' > $HOME/.pepe/config/tmp_genesis.json && mv $HOME/.pepe/config/tmp_genesis.json $HOME/.pepe/config/genesis.json
cat $HOME/.pepe/config/genesis.json | jq '.app_state["gov"]["deposit_params"]["min_deposit"][0]["denom"]="apepe"' > $HOME/.pepe/config/tmp_genesis.json && mv $HOME/.pepe/config/tmp_genesis.json $HOME/.pepe/config/genesis.json
cat $HOME/.pepe/config/genesis.json | jq '.app_state["evm"]["params"]["evm_denom"]="apepe"' > $HOME/.pepe/config/tmp_genesis.json && mv $HOME/.pepe/config/tmp_genesis.json $HOME/.pepe/config/genesis.json
cat $HOME/.pepe/config/genesis.json | jq '.app_state["inflation"]["params"]["mint_denom"]="apepe"' > $HOME/.pepe/config/tmp_genesis.json && mv $HOME/.pepe/config/tmp_genesis.json $HOME/.pepe/config/genesis.json

# Change voting params so that submitted proposals pass immediately for testing
cat $HOME/.pepe/config/genesis.json| jq '.app_state.gov.voting_params.voting_period="30s"' > $HOME/.pepe/config/tmp_genesis.json && mv $HOME/.pepe/config/tmp_genesis.json $HOME/.pepe/config/genesis.json


# disable produce empty block
if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' 's/create_empty_blocks = true/create_empty_blocks = false/g' $HOME/.pepe/config/config.toml
  else
    sed -i 's/create_empty_blocks = true/create_empty_blocks = false/g' $HOME/.pepe/config/config.toml
fi

if [[ $1 == "pending" ]]; then
  if [[ "$OSTYPE" == "darwin"* ]]; then
      sed -i '' 's/create_empty_blocks_interval = "0s"/create_empty_blocks_interval = "30s"/g' $HOME/.pepe/config/config.toml
      sed -i '' 's/timeout_propose = "3s"/timeout_propose = "30s"/g' $HOME/.pepe/config/config.toml
      sed -i '' 's/timeout_propose_delta = "500ms"/timeout_propose_delta = "5s"/g' $HOME/.pepe/config/config.toml
      sed -i '' 's/timeout_prevote = "1s"/timeout_prevote = "10s"/g' $HOME/.pepe/config/config.toml
      sed -i '' 's/timeout_prevote_delta = "500ms"/timeout_prevote_delta = "5s"/g' $HOME/.pepe/config/config.toml
      sed -i '' 's/timeout_precommit = "1s"/timeout_precommit = "10s"/g' $HOME/.pepe/config/config.toml
      sed -i '' 's/timeout_precommit_delta = "500ms"/timeout_precommit_delta = "5s"/g' $HOME/.pepe/config/config.toml
      sed -i '' 's/timeout_commit = "5s"/timeout_commit = "150s"/g' $HOME/.pepe/config/config.toml
      sed -i '' 's/timeout_broadcast_tx_commit = "10s"/timeout_broadcast_tx_commit = "150s"/g' $HOME/.pepe/config/config.toml
  else
      sed -i 's/create_empty_blocks_interval = "0s"/create_empty_blocks_interval = "30s"/g' $HOME/.pepe/config/config.toml
      sed -i 's/timeout_propose = "3s"/timeout_propose = "30s"/g' $HOME/.pepe/config/config.toml
      sed -i 's/timeout_propose_delta = "500ms"/timeout_propose_delta = "5s"/g' $HOME/.pepe/config/config.toml
      sed -i 's/timeout_prevote = "1s"/timeout_prevote = "10s"/g' $HOME/.pepe/config/config.toml
      sed -i 's/timeout_prevote_delta = "500ms"/timeout_prevote_delta = "5s"/g' $HOME/.pepe/config/config.toml
      sed -i 's/timeout_precommit = "1s"/timeout_precommit = "10s"/g' $HOME/.pepe/config/config.toml
      sed -i 's/timeout_precommit_delta = "500ms"/timeout_precommit_delta = "5s"/g' $HOME/.pepe/config/config.toml
      sed -i 's/timeout_commit = "5s"/timeout_commit = "150s"/g' $HOME/.pepe/config/config.toml
      sed -i 's/timeout_broadcast_tx_commit = "10s"/timeout_broadcast_tx_commit = "150s"/g' $HOME/.pepe/config/config.toml
  fi
fi

# Allocate genesis accounts (cosmos formatted addresses)
peped add-genesis-account $KEY 964723926400000000000000000apepe --keyring-backend $KEYRING
peped add-genesis-account $KEY2 35276073600000000000000000apepe --keyring-backend $KEYRING
                                 
# Update total supply with claim values
#validators_supply=$(cat $HOME/.pepe/config/genesis.json | jq -r '.app_state["bank"]["supply"][0]["amount"]')
# Bc is required to add this big numbers
# total_supply=$(bc <<< "$amount_to_claim+$validators_supply")
total_supply=1000000000000000000000000000
cat $HOME/.pepe/config/genesis.json | jq -r --arg total_supply "$total_supply" '.app_state["bank"]["supply"][0]["amount"]=$total_supply' > $HOME/.pepe/config/tmp_genesis.json && mv $HOME/.pepe/config/tmp_genesis.json $HOME/.pepe/config/genesis.json

echo $KEYRING
echo $KEY
# Sign genesis transaction
peped gentx $KEY2 100000000000000000000000apepe --keyring-backend $KEYRING --chain-id $CHAINID
#peped gentx $KEY2 1000000000000000000000apepe --keyring-backend $KEYRING --chain-id $CHAINID

# Collect genesis tx
peped collect-gentxs

# Run this to ensure everything worked and that the genesis file is setup correctly
peped validate-genesis

if [[ $1 == "pending" ]]; then
  echo "pending mode is on, please wait for the first block committed."
fi

# Start the node (remove the --pruning=nothing flag if historical queries are not needed)
peped start --pruning=nothing --trace --log_level info --minimum-gas-prices=0.0001apepe --json-rpc.api eth,txpool,personal,net,debug,web3 --rpc.laddr "tcp://0.0.0.0:26657" --api.enable true

