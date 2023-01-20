#!/bin/bash

###################################
### Sends ADA to Script address ###
###################################

# Address for change
payorADDR=$()
# UTXO which ADA will be spent from
payorUTXO=""
# How much ADA to spend
amountInLL=""
scriptADDR=$()
txSignatory=""

####################################
### No need to change code below ###
####################################

# Datum specfying owner and beneficiary attached to the resulting UTXO
datumHASH=$(cardano-cli transaction hash-script-data --script-data-file ../dist/datum.json)

tmpBuild=$(mktemp)

cardano-cli transaction build \
  --testnet-magic 1 \
  --change-address $payorADDR \
  --tx-in $payorUTXO \
  --tx-out "$scriptADDR $amountInLL lovelace" \
  --tx-out-datum-hash $datumHASH \
  --out-file $tmpBuild

[ $? -eq 0 ]  || { echo "Error building transaction"; exit 1; }

tmpSig=$(mktemp)

cardano-cli transaction sign \
  --tx-body-file $tmpBuild \
  --signing-key-file $txSignatory \
  --testnet-magic 1 \
  --out-file $tmpSig

cardano-cli transaction submit \
  --testnet-magic 1 \
  --tx-file $tmpSig

cardano-cli transaction txid --tx-file $tmpSig
