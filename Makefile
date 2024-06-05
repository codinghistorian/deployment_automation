# For Stablecoin project, Define the  repo URL and the directory to clone into
REPO_URL = https://github.com/Into-the-Fathom/fathom-stablecoin-smart-contracts.git
CLONE_DIR = projects/fathom-stablecoin-smart-contracts
BRANCH = FXD-127-New-deployment-process

# For the stablecoin project, define the source and destination paths for the private key
PRIVATE_KEY_SRC = configs/stablecoin/privateKey
PRIVATE_KEY_DEST = $(CLONE_DIR)/privateKey  # Adjust this path as needed

# For the stablecoin project, choose the deployment scenario in coralX-scenarios.js
SCENARIO = deployLocal

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
	cp configs/stablecoin/externalAddresses.json $(CLONE_DIR)/externalAddresses.json
	echo "Finished copying externalAddresses.json."

	echo "Copying coralX-config.js..."
	cp configs/stablecoin/coralX-config.js $(CLONE_DIR)/coralX-config.js
	echo "Finished copying coralX-config.js."

	echo "Copying initialCollateralSetUp.json..."
	cp configs/stablecoin/initialCollateralSetUp.json $(CLONE_DIR)/initialCollateralSetUp.json
	echo "Finished copying initialCollateralSetUp.json."

	echo "Copying coralX-scenarios.js..."
	cp configs/stablecoin/coralX-scenarios.js $(CLONE_DIR)/coralX-scenarios.js
	echo "Finished copying coralX-scenarios.js."

# Target to deploy the stablecoin contracts
stablecoin-deploy: stablecoin-copy-external-addresses
	cd ${CLONE_DIR} && coralX scenario --run ${SCENARIO}
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
	cp -r $(CLONE_DIR)/coralX-config.js stablecoinDeployResults/coralX-config.js
	cp -r $(CLONE_DIR)/initialCollateralSetUp.json stablecoinDeployResults/initialCollateralSetUp.json
	cp -r $(CLONE_DIR)/coralX-scenarios.js stablecoinDeployResults/coralX-scenarios.js
	cp -r $(CLONE_DIR)/privateKey stablecoinDeployResults/privateKey
	echo "Finished copying deployment results."

# Default target
all: fxd-stablecoin
	echo "All tasks completed."
