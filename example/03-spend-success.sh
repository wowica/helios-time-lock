#!/bin/bash

###################################
### Spends from Script Address  ###
###################################

# This transaction should succeed

# Script UTXO which will be spent from
scriptUTXO=""
# Populate with current slot from `cardano-cli query tip` command
currentSlot=""
# Needed for collateral. Should not be spent at all if tx succeeds.
payorUTXO="" # needed for collateral
# Change/Destination address
payorADDR=$()
# Payor PKH
payorPubKeyHash=$()
# Payor Signing key
txSignatory=""

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
  --out-file tx03.body

[ $? -eq 0 ]  || { echo "Error building transaction"; exit 1; }

cardano-cli transaction sign \
  --tx-body-file tx03.body \
  --signing-key-file $txSignatory \
  --testnet-magic 1 \
  --out-file tx03.signed

cardano-cli transaction submit \
  --testnet-magic 1 \
  --tx-file tx03.signed

cardano-cli transaction txid --tx-file tx03.signed
