#!/bin/bash

###################################
### Spends from Script Address  ###
###################################

# This transaction should succeed

scriptUTXO="" # script UTXO which will be spent from
currentSlot="" # populate with current slot from `cardano-cli query tip` command
payorUTXO="" # needed for collateral

payorADDR=$(cat wallets/03.addr)
# Generated via running the following command:
# $ cardano-cli address key-hash --payment-verification-key-file payment.vkey
payorPubKeyHash=$(cat wallets/03.pkh)

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
  --out-file tx03.body

[ $? -eq 0 ]  || { echo "Error building transaction"; exit 1; }

cardano-cli transaction sign \
  --tx-body-file tx03.body \
  --signing-key-file wallets/03.skey \
  --testnet-magic 1 \
  --out-file tx03.signed

cardano-cli transaction submit \
  --testnet-magic 1 \
  --tx-file tx03.signed

cardano-cli transaction txid --tx-file tx03.signed
