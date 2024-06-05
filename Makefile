# Define the repository URL and the directory to clone into
REPO_URL = https://github.com/Into-the-Fathom/fathom-stablecoin-smart-contracts.git
CLONE_DIR = projects/fathom-stablecoin-smart-contracts

# Define the source and destination paths for the private key
PRIVATE_KEY_SRC = configs/stablecoin/privateKey
PRIVATE_KEY_DEST = $(CLONE_DIR)/privateKey  # Adjust this path as needed

# Target to clone the repository
clone-stablecoin:
	echo "Cloning stablecoin repository..."
	if [ -d "$(CLONE_DIR)" ]; then rm -rf $(CLONE_DIR); fi
	git clone $(REPO_URL) $(CLONE_DIR)
	echo "Finished cloning stablecoin repo..."

# Target to copy the private key file
stablecoin-copy-private-key: clone-stablecoin
	echo "Copying private key file..."
	cp $(PRIVATE_KEY_SRC) $(PRIVATE_KEY_DEST)
	echo "Finished copying private key file."

# Command for stablecoin deployment
stablecoin-compile: stablecoin-copy-private-key
	cd ${CLONE_DIR} && npm i
	cd ${CLONE_DIR} && coralX compile
	echo "FXD smart contracts compiled."

# Default target
all: fxd-stablecoin
	echo "All tasks completed."
