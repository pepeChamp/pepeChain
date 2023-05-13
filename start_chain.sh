VERBOSE=$1
rm ./docs/static/openapi.yml
rm go.sum && touch go.sum
go mod tidy -e -go=1.17 && go mod tidy -e -go=1.18
ignite chain serve --config ./config.yml -r -f $VERBOSE