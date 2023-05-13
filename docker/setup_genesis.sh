default_pepe_home=pepe_home
pepe_HOME=$1
if [ -z "$pepe_HOME" ]; then
    pepe_HOME=$default_pepe_home
fi

## funtion setup_genesis
function setupGenesis() {
    NODE_PEER=$(jq '.app_state.genutil.gen_txs[0].body.memo' ./build/pepenode0/config/genesis.json)

    ## replace NODE_PEER in config.toml to persistent_peers
    sed -i '' "s/persistent_peers = \"\"/persistent_peers = ${NODE_PEER}/g" ./build/${pepe_HOME}/config/config.toml

    ## replace minimum-gas-prices = "0apepe" to minimum-gas-prices = "1.25apepe" in app.toml
    sed -i '' "s/minimum-gas-prices = \"0apepe\"/minimum-gas-prices = \"1.25apepe\"/g" ./build/${pepe_HOME}/config/app.toml

    ## replace to enalbe api
    sed -i '' "108s/.*/enable = true/" ./build/${pepe_HOME}/config/app.toml

    ## replace to from 127.0.0.1 to 0.0.0.0
    sed -i '' "s/127.0.0.1/0.0.0.0/g" ./build/${pepe_HOME}/config/config.toml

    ## config genesis.json
    jq '.app_state.bank.params.send_enabled[0] = {"denom": "apepe","enabled": true}' ./build/${pepe_HOME}/config/genesis.json | sponge ./build/${pepe_HOME}/config/genesis.json

    ## demom metadata
    jq '.app_state.bank.denom_metadata[0] =  {"description": "The native staking token of the pepe Protocol.","denom_units": [{"denom": "apepe","exponent": 0,"aliases": ["micropepe"]},{"denom": "mpepe","exponent": 3,"aliases": ["millipepe"]},{"denom": "pepe","exponent": 6,"aliases": []}],"base": "apepe","display": "pepe","name": "pepe token","symbol": "pepe"}' ./build/${pepe_HOME}/config/genesis.json | sponge ./build/${pepe_HOME}/config/genesis.json

    ## from stake to apepe
    sed -i '' "s/stake/apepe/g" ./build/${pepe_HOME}/config/genesis.json

    echo "Setup Genesis Success 🟢"

}

if [[ -e !./build/pepenode0/config/genesis.json ]]; then
    echo "File does not exist 🖕"
else
    setupGenesis
fi