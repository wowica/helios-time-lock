/*
* This script reads Helios code from validator.hl,
* populates Datum values for TIME_LOCK, OWNER and BENEFICIARY,
* and generates final artifacts which can be used to interact with
* the smart contract.
*
* See dist folder for artifacts, which include:
*   - validator.addr (testnet address)
*   - validator.json
*   - datum.json
*/

import { Program, Address, hexToBytes } from "@hyperionbt/helios"
import fs from "fs";

// Replace the following pubkeyhash values with your own values.
// These values can be generated using the following command:
// $ cardano-cli address key-hash --payment-verification-key-file <payment.vkey>
const ownerPKH = "6a317a7ca468cbc6ea3f0247241859f87db8beaeab288d1d69845ba9"
const beneficiaryPKH = "6bd95fcacb2373d68ae094fdefcc4811358e11ca0306a9f4b3bcbbe8"

// Used to set TIME_LOCK
const fiveMinsFromNow = (new Date()).getTime() + 1000 * 60 * 5;

// Reads the Helios source code
const src = fs.readFileSync('./validator.hl').toString();
const program = Program.new(src);

// Sets values for the Datum
program.changeParam("TIME_LOCK", JSON.stringify(fiveMinsFromNow));
program.changeParam("OWNER", JSON.stringify(hexToBytes(ownerPKH)));
program.changeParam("BENEFICIARY", JSON.stringify(hexToBytes(beneficiaryPKH)));

// Print the final Helios source code:
// console.log("\n" + program.toString() + "\n");

// must be set to false in order to print to log
const uplc = program.compile(false);
// set to false for mainnet address
const IS_TESTNET = true;

const scriptAddr = Address.
    fromValidatorHash(uplc.validatorHash, null, IS_TESTNET).
    toBech32();

console.log("\nGenerating Artifacts\n");

fs.writeFile('dist/validator.addr', scriptAddr, err => {
    if (err) {
        console.error(err);
    }
    console.log("Wrote to dist/validator.addr");
});

const validatorJSON = uplc.serialize();
fs.writeFile('dist/validator.json', validatorJSON, err => {
    if (err) {
        console.error(err);
    }
    console.log("Wrote to dist/validator.json");
});

const datum = program.evalParam("DATUM");
const datumJSON = datum.data.toSchemaJson();
fs.writeFile('dist/datum.json', datumJSON, err => {
    if (err) {
        console.error(err);
    }
    console.log("Wrote to dist/datum.json");
});