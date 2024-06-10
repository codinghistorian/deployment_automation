# Fathom Deployment Script

0.This project uses Makefile to orchestrate deployment and scripts needed for configs and maintenance of the protocol.
1.Makefile git clones, installs dependencies, compiles, copy config files from this project to cloned project, runs coralX scenarios
2.Initial collateral addition automatically uses simplePriceFeed as priceFeed. Please switch price feed once price aggregator for a collateral is ready.

## Stablecoin

Before running any of the scenario, please make sure that privateKey file is created with PK w/o 0x prefix in it in configs/stablecoin dir.
coralX-config.js is used for network configs.
coralX-scenario.js is used for scenario configs.
Please ensure network set up and scenario set up according to the new network are done properly before moving on to other scenario specific config files.

configs
├── stablecoin
│   ├── add-collateral
│   │   ├── add-collateral.json
│   │   └── newCollateralSetup.json
│   ├── coralX-config.js
│   ├── coralX-scenarios.js
│   ├── privateKey
│   ├── deployment
│   │   ├── externalAddresses.json
│   │   └── initialCollateralSetUp.json
│   ├── privateKey
│   └── switch-price-feed
│       └── setFathomPriceOracle.json

### coralX-scenario.js
Three scenarios; deployment, addCollateral, switchPriceFeed have examples in the file. Please add more scenarios for your needs.

### Stablecoin Config files

#### add-collateral
add-collateral.json : Token symbol and addresses used for add-collateral scenario is set in this file.
newCollateralSetup.json : New collateral's CDP config is done in this file.

#### deployment
externalAddresses.json : WNATIVE address for initial deployment of protocol to set NATIVE coin as the first collateral
initialCollateralSetUp.json : initial collateral's CDP config is done in this file.

#### switch-price-feed
setFathomPriceOracle.json : Token symbol and addresses used for price feed swtich from simplePriceFeed to CentralizedOraclePriceFeed is set in this file.

#### whitelisting
whitelisting.json : CollateralTokenAdapter and addresses to be whitelisted, FlashMintModule and addresses to be whitelisted, LiquidationEngine and addresses to be whitelisted

## Makefile for stablecoin
### Variables

#### Cloning repo
REPO_URL : github repo url to clone stablecoin project from
BRANCH : github repo branch to clone stablecoin project from

#### Deployment
INIT_DEPLOY_SCENARIO : deployment scenario set in coralX-scenarios.js. Please adjust according to your needs.

#### Add-collateral
ADD_COL_SCENARIO : add-collateral scenario set in coralX-scenarios.js. Please adjust according to your needs.

#### New collateral name for add-addCollateral
COL_NAME : Token symbol for add-collateral. Please make it sync with col name in configs/stablecoin/add-collateral/newCollateralSetup.json 's token symbol.

#### whitelisting
WHITELIST_SCENARIO : coralX scenario that will be used for whitelisting

### Stablecoin Makefile Targets
There is each target(command) to get run for all stablecoin three scenarios. 
When running target, please follow below format
$make ${targetName}

#### Deployment
make stablecoin-initial-deploy

#### Add-collateral
make stablecoin-add-collateral

#### Switch-price-feed
make stablecoin-switch-price-feed

#### Whitelisting
make stablecoin-whitelist

## Results targets

To check files generated from deployment scenario and add-collateral scenario, please check stablecoinDeployResults dir in root.