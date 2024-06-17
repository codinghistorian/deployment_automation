# Fathom Deployment Script

0.This project uses Makefile to orchestrate deployment and scripts needed for configs and maintenance of the protocol.<br>
1.Makefile git clones, installs dependencies, compiles, copy config files from this project to cloned project, runs coralX scenarios<br>
2.Initial collateral addition automatically uses simplePriceFeed as priceFeed. Please switch price feed once price aggregator for a collateral is ready.<br>

## Stablecoin

Before running any of the scenario, please make sure that privateKey file is created with PK w/o 0x prefix in it in configs/stablecoin dir.<br>
coralX-config.js is used for network configs.<br>
coralX-scenario.js is used for scenario configs.<br>
Please ensure network set up and scenario set up according to the new network are done properly before moving on to other scenario specific config files.<br>

### coralX-scenario.js
Three scenarios; deployment, addCollateral, switchPriceFeed have examples in the file. Please add more scenarios for your needs.

### privateKey
privateKey : a file that contains PK of EOA that will execute scenarios. Please create it in the configs/stablecoin/ dir <br>

### Stablecoin Config files

#### add-collateral
add-collateral.json : Token symbol and addresses used for add-collateral scenario is set in this file.<br>
newCollateralSetup.json : New collateral's CDP config is done in this file.<br>

#### deployment
externalAddresses.json : WNATIVE address for initial deployment of protocol to set NATIVE coin as the first collateral<br>
initialCollateralSetUp.json : initial collateral's CDP config is done in this file.<br>

#### switch-price-feed
setFathomPriceOracle.json : Token symbol and addresses used for price feed swtich from simplePriceFeed to CentralizedOraclePriceFeed is set in this file.<br>

#### whitelisting
whitelisting.json : CollateralTokenAdapter and addresses to be whitelisted, FlashMintModule and addresses to be whitelisted, LiquidationEngine and addresses to be whitelisted<br>

#### remove-from-whitelist
removeFromWL.json : CollateralTokenAdapter and addresses to be removed from WL, FlashMintModule and addresses to be removed from WL, LiquidationEngine and addresses to be removed from WL<br>

#### add-roles
addRoles.json : AccessControlConfig, Address_To_Add_Role addresses and roles bool. If any role's value is true, role will be added.<br>

#### revoke-roles
revokeRoles.json : AccessControlConfig, Address_To_Revoke_Role addresses and roles bool. If any role's value is true, role will be revoked.<br>

#### transfer-protocol-ownership
transferProtocolOwnership.json : AccessControlConfig, Address_To_Give_Ownership, Address_To_Renounce_Ownership addresses <br>

#### fee-collection
feeCollection.json : EOA that receives fee, and other contract addresses related to fee collection

## Makefile for stablecoin
### Variables

#### Cloning repo
REPO_URL : github repo url to clone stablecoin project from<br>
BRANCH : github repo branch to clone stablecoin project from<br>

#### Deployment
INIT_DEPLOY_SCENARIO : deployment scenario set in coralX-scenarios.js. Please adjust according to your needs.<br>

#### Add-collateral
ADD_COL_SCENARIO : add-collateral scenario set in coralX-scenarios.js. Please adjust according to your needs.<br>

#### New collateral name for add-addCollateral
COL_NAME : Token symbol for add-collateral. Please make it sync with col name in configs/stablecoin/add-collateral/newCollateralSetup.json 's token symbol.<br>

#### whitelisting
WHITELIST_SCENARIO : coralX scenario that will be used for whitelisting<br>

#### remove-from-whitelist
REMOVE_WL_SCENARIO: : coralX scenario that will be used for remove from WL<br>

#### add-roles
ADD_ROLES_SCENARIO : coralX scenario that will be used for add-roles<br>

#### revoke-roles
REVOKE_ROLES_SCENARIO : coralX scenario that will be used for revoke-roles<br>

#### transfer-protocol-ownership
TRANSFER_PROTOCOL_OWNERSHIP_SCENARIO : coralX scenario that will be used for transfer-protocol-ownership <br>

#### fee-collection
FEE_COLLECTION_SCENARIO : coralX scenario that is used for fee-collection

### Stablecoin Makefile Targets
There is each target(command) to get run for all stablecoin three scenarios. <br>
When running target, please follow below format<br>
$make ${targetName}<br>

#### Deployment
make stablecoin-initial-deploy

#### Add-collateral
make stablecoin-add-collateral

#### Switch-price-feed
make stablecoin-switch-price-feed

#### Whitelisting
make stablecoin-whitelist

#### remove-from-whitelist
make stablecoin-removeFromWL

#### add-roles
make stablecoin-add-roles<br>

#### revoke-roles
make stablecoin-revoke-roles<br>

#### transfer-protocol-ownership
make stablecoin-transfer-protocol-ownership

#### fee-collection
make stablecoin-fee-collection

#### 

### Check results
<br>
To check files generated from deployment scenario and add-collateral scenario, please check stablecoinDeployResults dir in root.