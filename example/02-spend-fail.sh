#!/bin/bash

###################################
### Spends from Script Address  ###
###################################

# This transaction uses a signatory different
# than either one specified by the datum at the UTXO,
# which means this transaction should FAIL every time.

# Keep running this script until the lock has been reached
# in order to see the error message change.

scriptUTXO="" # script UTXO which will be spent from
currentSlot="" # populate with current slot from `cardano-cli query tip` command
payorUTXO="" # needed for collateral

payorADDR=$(cat wallets/02.addr)
payorPubKeyHash=$(cat wallets/02.pkh)

# Should fail since signer is neither owner or beneficiary
cardano-cli transaction build \
  --testnet-magic 1 \
  --change-address ${payorADDR} \
  --tx-in ${scriptUTXO} \
  --tx-in-script-file validator.json \
  --tx-in-datum-file datum.json \
  --tx-in-redeemer-value 11 \
  --tx-in-collateral ${payorUTXO} \
  --required-signer-hash ${payorPubKeyHash} \
  --invalid-before ${currentSlot} \
  --protocol-params-file protocol-params.json \
  --out-file txFail.body # should not be created since command will fail

[ $? -eq 0 ]  || { echo "Error building transaction"; exit 1; }
