# For Stablecoin project, Define the  repo URL and the directory to clone into
REPO_URL = https://github.com/Into-the-Fathom/fathom-stablecoin-smart-contracts.git
CLONE_DIR = projects/fathom-stablecoin-smart-contracts
BRANCH = FXD-127-New-deployment-process

# For the stablecoin project, define the source and destination paths for the private key
PRIVATE_KEY_SRC = configs/stablecoin/privateKey
PRIVATE_KEY_DEST = $(CLONE_DIR)/privateKey  # Adjust this path as needed

# For the stablecoin project initial deployment, choose the deployment scenario in coralX-scenarios.js
INIT_DEPLOY_SCENARIO = deployLocal

#############################ADD-Collateral-DOWN############################################
# For the stablecoin project add collateral, choose the deployment scenario in coralX-scenarios.js
ADD_COL_SCENARIO = addCollateralLocal

# Specify collateral name
COL_NAME = CGO
#############################ADD-Collateral-UP############################################

SWITCH_PRICE_FEED_SCENARIO = switchPriceFeedLocal

WHITELIST_SCENARIO = whitelistCollateralTokenAdapterLocal

REMOVE_WL_SCENARIO = removeFromWLCollateralTokenAdapterLocal

ADD_ROLES_SCENARIO = addRolesLocal

REVOKE_ROLES_SCENARIO = revokeRolesLocal

TRANSFER_PROTOCOL_OWNERSHIP_SCENARIO = transferProtocolOwnershipLocal

TRANSFER_PROXY_ADMIN_OWNERSHIP_SCENARIO = transferProxyAdminOwnershipLocal

# Target to clone the repository
clone-stablecoin:
	echo "Cloning stablecoin repository..."
	if [ -d "$(CLONE_DIR)" ]; then rm -rf $(CLONE_DIR); fi
	git clone -b ${BRANCH} $(REPO_URL) $(CLONE_DIR)
	echo "Finished cloning stablecoin repo..."

# Target to copy the private key file
stablecoin-copy-private-key: clone-stablecoin
	echo "Copying private key file..."
	cp $(PRIVATE_KEY_SRC) $(PRIVATE_KEY_DEST)
	echo "Finished copying private key file."

# Target for stablecoin compilation
stablecoin-compile: stablecoin-copy-private-key
	cd ${CLONE_DIR} && npm i
	cd ${CLONE_DIR} && coralX compile
	echo "FXD smart contracts compiled."

# Target to copy externalAddresses.json, coralX-config.js, initialCollateralSetUp.json, coralX-scenarios.js
stablecoin-copy-external-addresses: stablecoin-compile
	echo "Copying externalAddresses.json..."
	cp configs/stablecoin/deployment/externalAddresses.json $(CLONE_DIR)/externalAddresses.json
	echo "Finished copying externalAddresses.json."

	echo "Copying coralX-config.js..."
	cp configs/stablecoin/coralX-config.js $(CLONE_DIR)/coralX-config.js
	echo "Finished copying coralX-config.js."

	echo "Copying initialCollateralSetUp.json..."
	cp configs/stablecoin/deployment/initialCollateralSetUp.json $(CLONE_DIR)/initialCollateralSetUp.json
	echo "Finished copying initialCollateralSetUp.json."

	echo "Copying coralX-scenarios.js..."
	cp configs/stablecoin/coralX-scenarios.js $(CLONE_DIR)/coralX-scenarios.js
	echo "Finished copying coralX-scenarios.js."

# Target to deploy the stablecoin contracts
stablecoin-deploy: stablecoin-copy-external-addresses
	cd ${CLONE_DIR} && coralX scenario --run ${INIT_DEPLOY_SCENARIO}
	echo "FXD smart contracts deployed."

# Target to copy addresses.json, 
# build folder, externalAddresses.json, coralX-config.js, 
# initialCollateralSetUp.json, coralX-scenarios.js, privateKey
# to the Root in a folder named stablecoinDeployResults
stablecoin-initial-deploy: stablecoin-deploy
	echo "Cleaning up previous stablecoinDeployResults directory if it exists..."
	# Remove the stablecoinDeployResults directory if it exists
	if [ -d stablecoinDeployResults ]; then rm -rf stablecoinDeployResults; fi
	echo "Copying deployment results to stablecoinDeployResults..."
	# Create the stablecoinDeployResults directory
	mkdir -p stablecoinDeployResults
	# Copy the necessary files and directories to stablecoinDeployResults
	cp -r $(CLONE_DIR)/addresses.json stablecoinDeployResults/addresses.json
	cp -r $(CLONE_DIR)/build stablecoinDeployResults/build
	cp -r $(CLONE_DIR)/externalAddresses.json stablecoinDeployResults/externalAddresses.json
	cp -r $(CLONE_DIR)/coralX-config.js stablecoinDeployResults/oralX-config.js
	cp -r $(CLONE_DIR)/initialCollateralSetUp.json stablecoinDeployResults/initialCollateralSetUp.json
	cp -r $(CLONE_DIR)/coralX-scenarios.js stablecoinDeployResults/coralX-scenarios-initial-deploy.js
	cp -r $(CLONE_DIR)/privateKey stablecoinDeployResults/privateKey
	echo "Finished copying deployment results."

# Target to add collateral
stablecoin-add-collateral: stablecoin-compile
	echo "Copying add-collateral.json..."
	cp configs/stablecoin/add-collateral/add-collateral.json $(CLONE_DIR)/add-collateral.json
	echo "Finished copying add-collateral.json."

	echo "Copying newCollateralSetup.json..."
	cp configs/stablecoin/add-collateral/newCollateralSetup.json $(CLONE_DIR)/newCollateralSetup.json
	echo "Finished copying newCollateralSetup.json."

	echo "Copying coralX-config.js..."
	cp configs/stablecoin/coralX-config.js $(CLONE_DIR)/coralX-config.js
	echo "Finished copying coralX-config.js."

	echo "Copying coralX-scenarios.js..."
	cp configs/stablecoin/coralX-scenarios.js $(CLONE_DIR)/coralX-scenarios.js
	echo "Finished copying coralX-scenarios.js."

	cd ${CLONE_DIR} && coralX scenario --run ${ADD_COL_SCENARIO}
	echo "Collateral added."

	cp -r $(CLONE_DIR)/addresses_${COL_NAME}.json stablecoinDeployResults/addresses_${COL_NAME}.json
	cp -r $(CLONE_DIR)/coralX-config.js stablecoinDeployResults/coralX-config-add-collateral.js
	cp -r $(CLONE_DIR)/coralX-scenarios.js stablecoinDeployResults/coralX-scenarios.js
	cp -r $(CLONE_DIR)/privateKey stablecoinDeployResults/privateKey
	echo "addresses_${COL_NAME}.json copied to stablecoinDeployResults."

# Target to switch price feed
stablecoin-switch-price-feed: stablecoin-compile
	echo "Copying setFathomPriceOracle.json..."
	cp configs/stablecoin/switch-price-feed/setFathomPriceOracle.json $(CLONE_DIR)/setFathomPriceOracle.json
	echo "Finished copying setFathomPriceOracle.json."

	echo "Copying coralX-scenarios.js..."
	cp configs/stablecoin/coralX-scenarios.js $(CLONE_DIR)/coralX-scenarios.js
	echo "Finished copying coralX-scenarios.js."

	cd ${CLONE_DIR} && coralX scenario --run ${SWITCH_PRICE_FEED_SCENARIO}
	echo "Price feed switched."\

# Target to whitelist address to collateral token adapter or FMM or LiquidationEngine
stablecoin-whitelist: stablecoin-compile
	echo "Copying whitelisting.json..."
	cp configs/stablecoin/whitelisting/whitelisting.json $(CLONE_DIR)/whitelisting.json
	echo "Finished copying whitelisting.json."

	echo "Copying coralX-scenarios.js..."
	cp configs/stablecoin/coralX-scenarios.js $(CLONE_DIR)/coralX-scenarios.js
	echo "Finished copying coralX-scenarios.js."

	cd ${CLONE_DIR} && coralX scenario --run ${WHITELIST_SCENARIO}
	echo "Whitelisted with ${WHITELIST_SCENARIO}}."

	cp -r $(CLONE_DIR)/coralX-scenarios.js stablecoinDeployResults/coralX-scenarios-whitelisting.js

# Target to remove from whitelist address to collateral token adapter or FMM or LiquidationEngine
stablecoin-removeFromWL: stablecoin-compile
	echo "Copying whitelisting.json..."
	cp configs/stablecoin/whitelisting/removeFromWL.json $(CLONE_DIR)/removeFromWL.json
	echo "Finished copying removeFromWL.json."

	echo "Copying coralX-scenarios.js..."
	cp configs/stablecoin/coralX-scenarios.js $(CLONE_DIR)/coralX-scenarios.js
	echo "Finished copying coralX-scenarios.js."

	cd ${CLONE_DIR} && coralX scenario --run ${REMOVE_WL_SCENARIO}
	echo "remove from WL with ${REMOVE_WL_SCENARIO}}."

	cp -r $(CLONE_DIR)/coralX-scenarios.js stablecoinDeployResults/coralX-scenarios-whitelisting.js


# Target to add roles
stablecoin-add-roles: stablecoin-compile
	echo "Copying add-roles.json..."
	cp configs/stablecoin/roles/addRoles.json $(CLONE_DIR)/addRoles.json
	echo "Finished copying add-roles.json."

	echo "Copying coralX-scenarios.js..."
	cp configs/stablecoin/coralX-scenarios.js $(CLONE_DIR)/coralX-scenarios.js
	echo "Finished copying coralX-scenarios.js."

	cd ${CLONE_DIR} && coralX scenario --run $(ADD_ROLES_SCENARIO)
	echo "Roles added."

	cp -r $(CLONE_DIR)/coralX-scenarios.js stablecoinDeployResults/coralX-scenarios-add-roles.js

# Target to revoke roles
stablecoin-revoke-roles: stablecoin-compile
	echo "Copying revokeRoles.json..."
	cp configs/stablecoin/roles/revokeRoles.json $(CLONE_DIR)/revokeRoles.json
	echo "Finished copying revokeRoles.json."

	echo "Copying coralX-scenarios.js..."
	cp configs/stablecoin/coralX-scenarios.js $(CLONE_DIR)/coralX-scenarios.js
	echo "Finished copying coralX-scenarios.js."

	cd ${CLONE_DIR} && coralX scenario --run $(REVOKE_ROLES_SCENARIO)
	echo "Roles revoked."

	cp -r $(CLONE_DIR)/coralX-scenarios.js stablecoinDeployResults/coralX-scenarios-revoke-roles.js

# Target to transfer protocol ownership
stablecoin-transfer-protocol-ownership: stablecoin-compile
	echo "Copying transferProtocolOwnership.json..."
	cp configs/stablecoin/ownership/transferProtocolOwnership.json $(CLONE_DIR)/transferProtocolOwnership.json
	echo "Finished copying transferProtocolOwnership.json."

	echo "Copying coralX-scenarios.js..."
	cp configs/stablecoin/coralX-scenarios.js $(CLONE_DIR)/coralX-scenarios.js
	echo "Finished copying coralX-scenarios.js."

	cd ${CLONE_DIR} && coralX scenario --run $(TRANSFER_PROTOCOL_OWNERSHIP_SCENARIO)
	echo "Protocol ownership transferred."

	cp -r $(CLONE_DIR)/coralX-scenarios.js stablecoinDeployResults/coralX-scenarios-transfer-protocol-ownership.js

# Target to transfer proxy admin ownership
stablecoin-transfer-proxy-admin-ownership: stablecoin-compile
	echo "Copying transferProxyAdminOwnership.json..."
	cp configs/stablecoin/ownership/transferProxyAdminOwnership.json $(CLONE_DIR)/transferProxyAdminOwnership.json
	echo "Finished copying transferProxyAdminOwnership.json."

	echo "Copying coralX-scenarios.js..."
	cp configs/stablecoin/coralX-scenarios.js $(CLONE_DIR)/coralX-scenarios.js
	echo "Finished copying coralX-scenarios.js."

	cd ${CLONE_DIR} && coralX scenario --run $(TRANSFER_PROXY_ADMIN_OWNERSHIP_SCENARIO)
	echo "Proxy admin ownership transferred."

	cp -r $(CLONE_DIR)/coralX-scenarios.js stablecoinDeployResults/coralX-scenarios-transfer-proxy-admin-ownership.js

# Default target
all: stablecoin-initial-deploy
	echo "All tasks completed."
