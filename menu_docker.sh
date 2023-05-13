default_github_token=$GIT_TOKEN
default_pepe_home=pepe_home
default_docker_tag="3.1.0"
node_homes=(
    pepenode0
    pepenode1
    pepenode2
    pepenode3
);
validator_keys=(
    val1
    val2
    val3
    val4
);

function setUpGenesis(){
       ## config genesis.json
    jq '.app_state.bank.params.send_enabled[0] = {"denom": "upepe","enabled": true}' ./build/pepenode0/config/genesis.json | sponge ./build/pepenode0/config/genesis.json

    ## bank
    jq '.app_state.bank.params.send_enabled[0] = {"denom": "upepe","enabled": true}' ./build/pepenode0/config/genesis.json | sponge ./build/pepenode0/config/genesis.json
    jq '.app_state.bank.denom_metadata[0] =  {"description": "The native staking token of the pepe Protocol.","denom_units": [{"denom": "upepe","exponent": 0,"aliases": ["micropepe"]},{"denom": "mpepe","exponent": 3,"aliases": ["millipepe"]},{"denom": "pepe","exponent": 6,"aliases": []}],"base": "upepe","display": "pepe","name": "pepe token","symbol": "pepe"}' ./build/pepenode0/config/genesis.json | sponge ./build/pepenode0/config/genesis.json
    jq '.app_state.bank.denom_metadata[1] =  {"description": "The native evm token of the pepe Protocol.","denom_units": [{"denom": "apepe","exponent": 0,"aliases": ["attopepe"]},{"denom": "upepe","exponent": 12,"aliases": ["micropepe"]},{"denom": "mpepe","exponent": 15,"aliases": ["millipepe"]},{"denom": "pepe","exponent": 18,"aliases": []}],"base": "apepe","display": "apepe","name": "apepe token","symbol": "apepe"}' ./build/pepenode0/config/genesis.json | sponge ./build/pepenode0/config/genesis.json


    ## from stake to upepe
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' "s/stake/upepe/g" ./build/pepenode0/config/genesis.json
    else
        sed -i "s/stake/upepe/g" ./build/pepenode0/config/genesis.json
    fi

    ## config genesis.json

    ## bank
    jq '.app_state.bank.params.send_enabled[0] = {"denom": "upepe","enabled": true}' ./build/pepenode0/config/genesiys.json | sponge ./build/pepenode0/config/genesis.json
    jq '.app_state.bank.denom_metadata[0] =  {"description": "The native staking token of the pepe Protocol.","denom_units": [{"denom": "upepe","exponent": 0,"aliases": .micropepe},{"denom": "mpepe","exponent": 3,"aliases": .millipepe},{"denom": "pepe","exponent": 6,"aliases": []}],"base": "upepe","display": "pepe","name": "pepe token","symbol": "pepe"}' ./build/pepenode0/config/genesis.json | sponge ./build/pepenode0/config/genesis.json
    jq '.app_state.bank.denom_metadata[1] =  {"description": "The native evm token of the pepe Protocol.","denom_units": [{"denom": "apepe","exponent": 0,"aliases": .attopepe},{"denom": "upepe","exponent": 12,"aliases": .micropepe},{"denom": "mpepe","exponent": 15,"aliases": .millipepe},{"denom": "pepe","exponent": 18,"aliases": []}],"base": "apepe","display": "apepe","name": "apepe token","symbol": "apepe"}' ./build/pepenode0/config/genesis.json | sponge ./build/pepenode0/config/genesis.json

    ## evm
    jq '.app_state.evm.params.evm_denom="apepe"' ./build/pepenode0/config/genesis.json | sponge ./build/pepenode0/config/genesis.json

    ## feemarket
    jq '.app_state.feemarket.params.base_fee = "5000000000000"' ./build/pepenode0/config/genesis.json | sponge ./build/pepenode0/config/genesis.json
    jq '.app_state.feemarket.params.elasticity_multiplier = 4' ./build/pepenode0/config/genesis.json | sponge ./build/pepenode0/config/genesis.json
    jq '.app_state.feemarket.params.min_gas_price = "5000000000000.000000000000000000"' ./build/pepenode0/config/genesis.json | sponge ./build/pepenode0/config/genesis.json
    
    ## nftadmin
    jq '.app_state.nftadmin.authorization = {"root_admin": "6x1t3p2vzd7w036ahxf4kefsc9sn24pvlqphcuauv"}' ./build/pepenode0/config/genesis.json | sponge ./build/pepenode0/config/genesis.json

    ## nftmngr
    jq '.app_state.nftmngr.nft_fee_config = {"schema_fee": {"fee_amount": "200000000upepe","fee_distributions": [{"method": "BURN","portion": 0.5},{"method": "REWARD_POOL","portion": 0.5}]}}' ./build/pepenode0/config/genesis.json | sponge ./build/pepenode0/config/genesis.json

    ## nftoracle
    jq '.app_state.nftoracle.params = {"action_request_active_duration": "120s","mint_request_active_duration": "120s","verify_request_active_duration": "120s", "action_signer_active_duration": "2592000s","sync_action_signer_active_duration": "300s"}' ./build/pepenode0/config/genesis.json | sponge ./build/pepenode0/config/genesis.json
    jq '.app_state.nftoracle.oracle_config = {"minimum_confirmation": 4}' ./build/pepenode0/config/genesis.json | sponge ./build/pepenode0/config/genesis.json

    ## protocoladmin
    jq '.app_state.protocoladmin.adminList[0] |= . + {"admin": "6x1t3p2vzd7w036ahxf4kefsc9sn24pvlqphcuauv","group": "super.admin"}' ./build/pepenode0/config/genesis.json | sponge ./build/pepenode0/config/genesis.json
    jq '.app_state.protocoladmin.adminList[1] |= . + {"admin": "6x1t3p2vzd7w036ahxf4kefsc9sn24pvlqphcuauv","group": "token.admin"}' ./build/pepenode0/config/genesis.json | sponge ./build/pepenode0/config/genesis.json
    jq '.app_state.protocoladmin.groupList[0] |= . + {"name": "super.admin","owner": "6x1t3p2vzd7w036ahxf4kefsc9sn24pvlqphcuauv"}' ./build/pepenode0/config/genesis.json | sponge ./build/pepenode0/config/genesis.json
    jq '.app_state.protocoladmin.groupList[1] |= . + {"name": "token.admin","owner": "6x1t3p2vzd7w036ahxf4kefsc9sn24pvlqphcuauv"}' ./build/pepenode0/config/genesis.json | sponge ./build/pepenode0/config/genesis.json

    ## staking 
    jq '.app_state.staking.validator_approval.approver_address = "6x1t3p2vzd7w036ahxf4kefsc9sn24pvlqphcuauv"' ./build/pepenode0/config/genesis.json | sponge ./build/pepenode0/config/genesis.json

    ## tokenmngr
    jq '.app_state.tokenmngr.mintpermList[0] |= . + {"address": "6x1myrlxmmasv6yq4axrxmdswj9kv5gc0ppx95rmq","creator": "6x1t3p2vzd7w036ahxf4kefsc9sn24pvlqphcuauv","token": "upepe"}' ./build/pepenode0/config/genesis.json | sponge ./build/pepenode0/config/genesis.json
    jq '.app_state.tokenmngr.options = {"defaultMintee": "6x1cws3ex5yqwlu4my49htq06nsnhuxw3v7rt20g6"}' ./build/pepenode0/config/genesis.json | sponge ./build/pepenode0/config/genesis.json
    jq '.app_state.tokenmngr.tokenList[0] |= . +  {"base": "upepe","creator": "6x1t3p2vzd7w036ahxf4kefsc9sn24pvlqphcuauv","maxSupply": {"amount": "0","denom": "upepe"},"mintee": "6x1myrlxmmasv6yq4axrxmdswj9kv5gc0ppx95rmq","name": "upepe"}' ./build/pepenode0/config/genesis.json | sponge ./build/pepenode0/config/genesis.json 
    jq '.app_state.tokenmngr.tokenList[1] |= . +  {"base": "apepe","creator": "6x1t3p2vzd7w036ahxf4kefsc9sn24pvlqphcuauv","maxSupply": {"amount": "0","denom": "apepe"},"mintee": "6x1myrlxmmasv6yq4axrxmdswj9kv5gc0ppx95rmq","name": "apepe"}' ./build/pepenode0/config/genesis.json | sponge ./build/pepenode0/config/genesis.json

    ## gov
    jq '.app_state.gov.deposit_params.max_deposit_period = "300s"' ./build/pepenode0/config/genesis.json | sponge ./build/pepenode0/config/genesis.json
    jq '.app_state.gov.voting_params.voting_period = "300s"' ./build/pepenode0/config/genesis.json | sponge ./build/pepenode0/config/genesis.json
}

function setUpConfig() {
    echo "#######################################"
    echo "Setup pepenode0 genesis..."

    if [[ pepenode0 == "pepenode0" ]]; then
        echo "pepenode0"
        # NODE_PEER=$(jq '.app_state.genutil.gen_txs[0].body.memo' ./build/pepenode1/config/genesis.json)
        # sed -i '' "s/persistent_peers = \"\"/persistent_peers = ${NODE_PEER}/g" ./build/pepenode0/config/config.toml
        ## setup genesis of node0
        setUpGenesis
    else
        NODE_PEER=$(jq '.app_state.genutil.gen_txs[0].body.memo' ./build/pepenode0/config/genesis.json)
        if [[ "$OSTYPE" == "darwin"* ]]; then
            ## replace NODE_PEER in config.toml to persistent_peers
            sed -i '' "s/persistent_peers = \"\"/persistent_peers = ${NODE_PEER}/g" ./build/pepenode0/config/config.toml
        else
            sed -i "s/persistent_peers = \"\"/persistent_peers = ${NODE_PEER}/g" ./build/pepenode0/config/config.toml
        fi
            ## replace genesis of node0 to all node
        cp ./build/pepenode0/config/genesis.json ./build/pepenode0/config/genesis.json
    fi

    # if $TYPE = 0 then ignore this step
    if [[ ${TYPE} == "1" ]]; then
        echo "Running Fast Node"
        ## replace consensus params
        if [[ "$OSTYPE" == "darwin"* ]]; then
            sed -i '' "s/timeout_propose = \"3s\"/timeout_propose = \"1s\"/g" ./build/pepenode0/config/config.toml
            sed -i '' "s/timeout_commit = \"5s\"/timeout_commit = \"1s\"/g" ./build/pepenode0/config/config.toml
        else
            sed -i "s/timeout_propose = \"3s\"/timeout_propose = \"1s\"/g" ./build/pepenode0/config/config.toml
            sed -i "s/timeout_commit = \"5s\"/timeout_commit = \"1s\"/g" ./build/pepenode0/config/config.toml
        fi
    else
        echo "Running Default Node"
    fi
    
    if [[ "$OSTYPE" == "darwin"* ]]; then
        ## replace to enalbe api
        sed -i '' '/^\[api\]$/,/^\[/ s/enable = false/enable = true/' ./build/${pepe_HOME}/config/app.toml
        sed -i '' '/^\[api\]$/,/^[^[]/ s/^swagger = false$/swagger = true/' ./build/${pepe_HOME}/config/app.toml
        ## replace to from 127.0.0.1 to 0.0.0.0
        sed -i '' "s/127.0.0.1/0.0.0.0/g" ./build/${pepe_HOME}/config/config.toml

        ## replace mininum gas price
        sed -i '' "s/minimum-gas-prices = \"0stake\"/minimum-gas-prices = \"1.25upepe,1250000000000apepe\"/g" ./build/${pepe_HOME}/config/app.toml
    else
        sed -i '/^\[api\]$/,/^\[/ s/enable = false/enable = true/' ./build/${pepe_HOME}/config/app.toml
        sed -i '/^\[api\]$/,/^[^[]/ s/^swagger = false$/swagger = true/' ./build/${pepe_HOME}/config/app.toml
        ## replace to from 127.0.0.1 to 0.0.0.0
        sed -i "s/127.0.0.1/0.0.0.0/g" ./build/${pepe_HOME}/config/config.toml

        ## replace mininum gas price
        sed -i "s/minimum-gas-prices = \"0stake\"/minimum-gas-prices = \"1.25upepe,1250000000000apepe\"/g" ./build/${pepe_HOME}/config/app.toml
    fi

    echo "Setup Genesis Success 🟢"

}

echo "#############################################"
echo "## 1. Build Docker Image                   ##"
echo "## 2. Docker Compose init chain            ##"
echo "## 3. Start chain validator                ##"
echo "## 4. Stop chain validator                 ##"
echo "## 5. Config Genesis                       ##"
echo "## 6. Reset chain validator                ##"
echo "## 7. Staking validator                    ##"
echo "## 8. Query Validator set                  ##"
echo "## 9. Setup Cosmovisor                     ##"
echo "## 10. Start Cosmovisor                    ##"
echo "#############################################"
read -p "Enter your choice: " choice
case $choice in
    1)
        echo "Building Docker Image"
        read -p "Enter Github Token: " github_token 
        read -p "Enter Docker Tag: " docker_tag
        if [ -z "$github_token" ]; then
            github_token=$default_github_token
        fi
        if [ -z "$docker_tag" ]; then
            docker_tag=$default_docker_tag
        fi
        docker build . -t gcr.io/pepe-protocol/pepenode:${docker_tag} --build-arg GITHUB_TOKEN=${github_token}
        ;;
    2)
        echo "Run init Chain validator"
        export COMMAND="init"
        docker compose -f ./docker-compose.yml up
        ;;
    3)
        echo "Running Docker Container in Interactive Mode"
        export COMMAND="start_chain"
        docker compose -f ./docker-compose.yml up -d
        ;;
    4)
        echo "Stop Docker Container"
        export COMMAND="start_chain"
        docker compose -f ./docker-compose.yml down
        ;;
    5) 
        echo "Config Genesis"
        read -p "Enter Node Type [0:Default, 1:Fast] : " TYPE
        if [ -z "$TYPE" ]; then
            TYPE=0
        fi
        for home in ${node_homes[@]}
        do  
            (
            export pepe_HOME=${home}
            if [[ ! -e ./build/pepenode0/config/genesis.json ]]; then
                echo "File does not exist 🖕"
            else
                setUpConfig
            fi 
            )|| exit 1
        done
        ;;
    6) 
        echo "Reset Docker Container"
        for home in ${node_homes[@]}
        do
            echo "#######################################"
            echo "Starting ${home} reset..."

            ( export DAEMON_HOME=./build/${home}
            rm -rf $DAEMON_HOME/data
            rm -rf $DAEMON_HOME/wasm
            rm $DAEMON_HOME/config/addrbook.json
            mkdir $DAEMON_HOME/data/
            touch $DAEMON_HOME/data/priv_validator_state.json
            echo '{"height": "0", "round": 0,"step": 0}' > $DAEMON_HOME/data/priv_validator_state.json

            echo "Reset ${home} Success 🟢"
            )|| exit 1
        done
        ;;
    7)
        echo "Staking Docker Container"
        i=1
        amount=100000001
        # i=0
        # for val in ${validator_keys[@]}
        for val in ${validator_keys[@]:1:3}
        do
         # if i=3, echo "#######################################"
            if [[ $i -eq 2 ]]; then
                echo "#######################################"
                ( 
                echo "Creating validators ${val}"
                echo ${node_homes[i]}
                export DAEMON_HOME=./build/${node_homes[i]}
                peped tx staking create-validator --amount 1000000upepe --license-mode=true --max-license=1 --pubkey $(peped tendermint show-validator --home ./build/${node_homes[i]}) --home build/${node_homes[i]} \
                    --min-delegation 1000000 --delegation-increment 1000000 --enable-redelegation=false --moniker ${node_homes[i]} --from=${val} \
                    --commission-rate "0.1" --commission-max-rate "0.1" \
                    --commission-max-change-rate "0.1" --chain-id pepe_666-1 \
                    --sign-mode amino-json --gas auto --gas-adjustment 1.5 --gas-prices 1.25upepe --min-self-delegation 1000000 --keyring-backend test -y
                echo "Config Genesis at ${home} Success 🟢"
                ) || exit 1
            else
                echo "#######################################"
                ( 
                echo "Creating validators ${val}"
                echo ${node_homes[i]}
                export DAEMON_HOME=./build/${node_homes[i]}
                peped tx staking create-validator --amount="${amount}upepe" --from=${val} --moniker ${node_homes[i]} \
                    --pubkey $(peped tendermint show-validator --home ./build/${node_homes[i]}) --home build/${node_homes[i]} \
                    --keyring-backend test --commission-rate 0.1 --commission-max-rate 0.5 --commission-max-change-rate 0.1 \
                    --min-self-delegation 1000000 --node http://0.0.0.0:26662 -y --min-delegation 1000000 --delegation-increment 1000000 \
                    --chain-id pepe_666-1 --gas auto --gas-adjustment 1.5 --gas-prices 1.25upepe -y
                echo "Config Genesis at ${home} Success 🟢"
                ) || exit 1
            fi
            i=$((i+1))
            amount=$((amount+1))
        done
        ;;
    8)
        echo "Query Validator set"
        peped q tendermint-validator-set --home ./build/pepenode0
        ;;
    9)
        echo "Set up Cosmovisor"
        export COMMAND="cosmovisor_setup"
        docker compose -f ./docker-compose.yml up -d
        ;;
    10)
        echo "Cosmovisor start"
        export COMMAND="cosmovisor_start"
        docker compose -f ./docker-compose.yml up -d
        ;;
    *)
        echo "Invalid Choice"
        ;;
esac