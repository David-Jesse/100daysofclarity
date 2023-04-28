import { Clarinet, Tx, Chain, Account, Contract, types } from 'https://deno.land/x/clarinet@v1.5.4/index.ts';
import { assertEquals } from 'https://deno.land/std@0.170.0/testing/asserts.ts';

// Two tests
// 1. Can mint onf FT
// 2. Cannot mint another

Clarinet.test({
    name: "Ensure that exactly 1 CT is transferred on mint",
    async fn(chain: Chain, accounts: Map<string, Account>, contracts: Map<string, Contract>) {
        let deployer = accounts.get("deployer")!;

        let block = chain.mineBlock([
            Tx.contractCall("simple-ft", "claim-ct", [], deployer.address)
        ])

        console.log(block.receipts[0].events)

        block.receipts[0].events.expectFungibleTokenMintEvent(
            1,
            deployer.address,
            "clarity-token"
        )
    }
})