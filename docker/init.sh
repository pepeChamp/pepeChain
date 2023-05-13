MONIKER=$1
# if no moniker passed, set to default
if [ -z "$MONIKER" ]; then
  MONIKER="mynode"
fi
export CHAIN_ID=pepe_666-1
export VALKEY=val1 # should be: export as docker env var
export pepe_HOME=./build/pepe_home
ALICE_MNEMONIC="history perfect across group seek acoustic delay captain sauce audit carpet tattoo exhaust green there giant cluster want pond bulk close screen scissors remind"
BOB_MNEMONIC="limb sister humor wisdom elephant weasel beyond must any desert glance stem reform soccer include chest chef clerk call popular display nerve priority venture"
VAL1_MNEMONIC="note base stone list envelope tail start forget alarm acoustic cook occur divert giant bike curtain chase shuffle fade glow capital slot file provide"
VAL2_MNEMONIC="strike tower consider despair bridge diesel clay celery violin base hello ride they weather tunnel elite truth oblige spot hen wise flag pet battle"
VAL3_MNEMONIC="canvas human require month loan oak december blame grit palm slice error absorb total spice autumn trouble soda repeat shove quit bid forward organ"
VAL4_MNEMONIC="grant raw marine drink text dove flat waste wish buzz output hand merge cluster civil clog stay alert silent reunion idea cake village almost"
ORACLE1_MNEMONIC="list split future remain scene cheap pledge forum siren purse bright ivory split morning swing dumb fabric rapid remove worth diary task island donkey"
ORACLE2_MNEMONIC="achieve rice anger junk delay glove slam find poem feed emerge next core twice kitchen road proof remain notice slice walk super piece father"
ORACLE3_MNEMONIC="hint expose mix lemon leave genuine host fiction peasant daughter enable region mixture bean soda auction armed turtle iron become bracket wasp drama front"
ORACLE4_MNEMONIC="clown cabbage clean design mosquito surround citizen virus kite castle sponsor wife lesson coffee alien panel hand together good crazy fabric mouse hat town"
SUPER_ADMIN_MNEMONIC="expect peace defense conduct virtual flight flip unit equip solve broccoli protect shed group else useless tree such tornado minimum decade tower warfare galaxy"

rm -Rf ${pepe_HOME}

peped init ${MONIKER} --chain-id=${CHAIN_ID} --home ${pepe_HOME}

# Change parameter token denominations to apepe
cat ${pepe_HOME}/config/genesis.json | jq '.app_state["staking"]["params"]["bond_denom"]="apepe"' > ${pepe_HOME}/config/tmp_genesis.json && mv ${pepe_HOME}/config/tmp_genesis.json ${pepe_HOME}/config/genesis.json
cat ${pepe_HOME}/config/genesis.json | jq '.app_state["crisis"]["constant_fee"]["denom"]="apepe"' > ${pepe_HOME}/config/tmp_genesis.json && mv ${pepe_HOME}/config/tmp_genesis.json ${pepe_HOME}/config/genesis.json
cat ${pepe_HOME}/config/genesis.json | jq '.app_state["gov"]["deposit_params"]["min_deposit"][0]["denom"]="apepe"' > ${pepe_HOME}/config/tmp_genesis.json && mv ${pepe_HOME}/config/tmp_genesis.json ${pepe_HOME}/config/genesis.json
cat ${pepe_HOME}/config/genesis.json | jq '.app_state["evm"]["params"]["evm_denom"]="apepe"' > ${pepe_HOME}/config/tmp_genesis.json && mv ${pepe_HOME}/config/tmp_genesis.json ${pepe_HOME}/config/genesis.json
cat ${pepe_HOME}/config/genesis.json | jq '.app_state["inflation"]["params"]["mint_denom"]="apepe"' > ${pepe_HOME}/config/tmp_genesis.json && mv ${pepe_HOME}/config/tmp_genesis.json ${pepe_HOME}/config/genesis.json


# mint to validator
echo $SUPER_ADMIN_MNEMONIC | peped keys add super-admin --recover --home ${pepe_HOME} --algo eth_secp256k1 --keyring-backend test
echo $ALICE_MNEMONIC | peped keys add alice --recover --home ${pepe_HOME} --algo eth_secp256k1 --keyring-backend test
echo $BOB_MNEMONIC | peped keys add bob --recover --home ${pepe_HOME} --algo eth_secp256k1 --keyring-backend test
echo $VAL1_MNEMONIC | peped keys add val1 --recover --home ${pepe_HOME} --algo eth_secp256k1 --keyring-backend test
echo $VAL2_MNEMONIC | peped keys add val2 --recover --home ${pepe_HOME} --algo eth_secp256k1 --keyring-backend test
echo $VAL3_MNEMONIC | peped keys add val3 --recover --home ${pepe_HOME} --algo eth_secp256k1 --keyring-backend test
echo $VAL4_MNEMONIC | peped keys add val4 --recover --home ${pepe_HOME} --algo eth_secp256k1 --keyring-backend test

peped add-genesis-account $(peped keys show -a val1 --keyring-backend=test --home ${pepe_HOME}) 1000000000000apepe --keyring-backend test --home ${pepe_HOME}
peped add-genesis-account $(peped keys show -a val2 --keyring-backend=test --home ${pepe_HOME}) 1000000000000apepe --keyring-backend test --home ${pepe_HOME}
peped add-genesis-account $(peped keys show -a val3 --keyring-backend=test --home ${pepe_HOME}) 1000000000000apepe --keyring-backend test --home ${pepe_HOME}
peped add-genesis-account $(peped keys show -a val4 --keyring-backend=test --home ${pepe_HOME}) 1000000000000apepe --keyring-backend test --home ${pepe_HOME}
peped add-genesis-account $(peped keys show -a alice --keyring-backend=test --home ${pepe_HOME}) 1000000000000apepe --keyring-backend test --home ${pepe_HOME}
peped add-genesis-account $(peped keys show -a bob --keyring-backend=test --home ${pepe_HOME}) 1000000000000apepe --keyring-backend test --home ${pepe_HOME}
peped add-genesis-account $(peped keys show -a super-admin --keyring-backend=test --home ${pepe_HOME}) 1000000000000apepe --keyring-backend test --home ${pepe_HOME}

peped gentx ${VALKEY} 100000000000apepe --chain-id=${CHAIN_ID} --keyring-backend=test --home ${pepe_HOME}
peped collect-gentxs --home ${pepe_HOME}