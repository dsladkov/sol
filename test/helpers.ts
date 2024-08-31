import {GuideDAOToken} from "../typechain-types";

//this function multiply input value on token exponent power  
async function withDecimals(gtk: GuideDAOToken, value: bigint): Promise<bigint> {
    return value * 10n ** await gtk.decimals();
}

export {withDecimals};