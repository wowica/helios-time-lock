#!/bin/bash

###################################
### Spends from Script Address  ###
###################################

# Keep running this script until the lock has been reached
# in order to see the error message change.

# Script UTXO which will be spent from
scriptUTXO="" 
# Populate with current slot from `cardano-cli query tip` command
currentSlot=""
# Needed for collateral
payorUTXO=""
# Change address
payorADDR=$()
# PKH
payorPubKeyHash=$()

# Should fail since signer is neither owner or beneficiary
cardano-cli transaction build \
  --testnet-magic 1 \
  --change-address ${payorADDR} \
  --tx-in ${scriptUTXO} \
  --tx-in-script-file ../dist/validator.json \
  --tx-in-datum-file ../dist/datum.json \
  --tx-in-redeemer-value 11 \
  --tx-in-collateral ${payorUTXO} \
  --required-signer-hash ${payorPubKeyHash} \
  --invalid-before ${currentSlot} \
  --protocol-params-file protocol.json \
  --out-file txFail.body # should not be created since command will fail

[ $? -eq 0 ]  || { echo "Error building transaction"; exit 1; }

echo "Transaction should have failed"
exit 1;
