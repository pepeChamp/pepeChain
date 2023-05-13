package main

import (
	"os"

	"github.com/cosmos/cosmos-sdk/server"
	svrcmd "github.com/cosmos/cosmos-sdk/server/cmd"

	"github.com/pepeChamp/pepeChain/app"
	"github.com/pepeChamp/pepeChain/cmd/peped/cmd"
	cmdcfg "github.com/pepeChamp/pepeChain/cmd/peped/config"
)

func main() {
	app.SetConfig()
	cmdcfg.RegisterDenoms()
	rootCmd, _ := cmd.NewRootCmd()

	if err := svrcmd.Execute(rootCmd, app.DefaultNodeHome); err != nil {
		switch e := err.(type) {
		case server.ErrorCode:
			os.Exit(e.Code)

		default:
			os.Exit(1)
		}
	}
}
