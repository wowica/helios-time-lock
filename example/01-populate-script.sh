#!/bin/bash

###################################
### Sends ADA to Script address ###
###################################

# Address for change
payorADDR=$(cat wallets/01.addr)
# UTXO which ADA will be spent from
payorUTXO=""
# Datum specfying owner and beneficiary attached to the resulting UTXO
datumHASH=$(cardano-cli transaction hash-script-data --script-data-file datum.json)

cardano-cli transaction build \
  --testnet-magic 1 \
  --change-address $payorADDR \
  --tx-in $payorUTXO \
  --tx-out "$(cat validator.addr) 5000000 lovelace" \
  --tx-out-datum-hash $datumHASH \
  --out-file tx01.body

[ $? -eq 0 ]  || { echo "Error building transaction"; exit 1; }

cardano-cli transaction sign \
  --tx-body-file tx01.body \
  --signing-key-file wallets/01.skey \
  --testnet-magic 1 \
  --out-file tx01.signed

cardano-cli transaction submit \
  --testnet-magic 1 \
  --tx-file tx01.signed

cardano-cli transaction txid --tx-file tx01.signed
