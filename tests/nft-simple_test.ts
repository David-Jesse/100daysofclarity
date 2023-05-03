
import { Clarinet, Tx, Chain, Account, Contract, types } from 'https://deno.land/x/clarinet@v1.4.0/index.ts';
import { assertEquals } from 'https://deno.land/std@0.170.0/testing/asserts.ts';

Clarinet.test({
    name: "Ensure that the right NFT is minted to the right address",
    async fn(chain: Chain, accounts: Map<string, Account>, contracts: Map<string, Contract>) {
        let deployer = accounts.get("deployer")!;
        let wallet_1 = accounts.get("wallet_1")!;

        let block = chain.mineBlock([
            Tx.contractCall("nft-simple", "mint", [], wallet_1.address)
        ]);

        block.receipts[0].result.expectOk().expectBool(true);
        
        console.log(block.receipts[0].eevents)
        
        block.receipts[0].events.expectNonFungibleTokenMintEvent(
             types.uint(1),
             wallet_1.address,
             deployer.address   
            `${deployer.address}.nft-simple`,
            "simple-nft"
        )

    }
})


// Clarinet.test({
//     name: "Ensure that the right amount of STX (nft price) is transferred by checking balance ",
//     async fn(chain: Chain, accounts: Map<string, Account>, contracts: Map<string, Contract>) {
//         let deployer = accounts.get("deployer")!;
//         let wallet_1 = accounts.get("wallet_1")!;

//         let block = chain.mineBlock([
//             Tx.contractCall("nft-simple", "mint", [], wallet_1.address)
//         ]);

//         block.receipts[0].result.expectOk().expectBool(true);
        
//         console.log(block.receipts[0].eevents)
        
//         assertEquals(chain.getAssertMaps().assets['STX'] [wallet_1_address], 99999990000000)

//     }
// })
