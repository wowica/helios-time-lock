#!/bin/bash

# The goal of this script is to send all ADA from
# one address to another

destADDR=""
payorUTXO=""
txSignatory=""

# First, run this script with fee value empty so that fee
# can be calculated and printed to the screen.
# Then, populate this variable with the amount displayed
# and run script again.
fee=""
amountInLL=""

if [[ "$fee" -le 0 ]]; then
  tmpFile=$(mktemp)

  echo "Tx Fee: "

  cardano-cli transaction build-raw \
    --tx-in $payorUTXO \
    --tx-out "$destADDR 0 lovelace" \
    --fee 0 \
    --out-file $tmpFile

  cardano-cli transaction calculate-min-fee \
      --testnet-magic 1 \
      --tx-body-file $tmpFile \
      --tx-in-count 1 \
      --tx-out-count 1 \
      --witness-count 1 \
      --protocol-params-file protocol.json

  exit 0
fi

tmpRaw=$(mktemp)

cardano-cli transaction build-raw \
  --tx-in $payorUTXO \
  --tx-out "$destADDR $amountInLL lovelace" \
  --fee $fee \
  --out-file $tmpRaw

[ $? -eq 0 ]  || { echo "Error building transaction"; exit 1; }

tmpSig=$(mktemp)

cardano-cli transaction sign \
  --tx-body-file $tmpRaw \
  --signing-key-file $txSignatory \
  --testnet-magic 1 \
  --out-file $tmpSig

cardano-cli transaction submit \
  --testnet-magic 1 \
  --tx-file $tmpSig

cardano-cli transaction txid --tx-file $tmpSig