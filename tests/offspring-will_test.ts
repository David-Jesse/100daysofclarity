// https://deno.land/x/clarinet@v1.4.0/index.ts
import { Clarinet, Tx, Chain, Account, types } from 'https://deno.land/x/clarinet@v1.4.0/index.ts';
import { assertEquals } from 'https://deno.land/std@0.170.0/testing/asserts.ts';

Clarinet.test({
    name: "Ensure that <...>",
    async fn(chain: Chain, accounts: Map<string, Account>) {
        let block = chain.mineBlock([
            /*
             * Add transactions with:
             * Tx.contractCall(...)
            */
        ]);
        // assertEquals(block.receipts.length, 0);
        // assertEquals(block.height, 2);

        block = chain.mineBlock([
            /*
             * Add transactions with:
             * Tx.contractCall(...)
            */
        ]);
        // assertEquals(block.receipts.length, 0);
        // assertEquals(block.height, 3);
    },
});

Clarinet.test({
    name: "Get non-existent offspring-wallet, return none",
    async fn(chain: Chain, accounts: Map<string, Account>) {

        // All function to test
        // let deploy = accounts.get("deployer")!;
        // let wallet_1 = accounts.get("wallet_1")!;
        
        // let readResult = chain.callReadOnlyFn("offspring-will", "get-offspring-wallet", [types.principal(wallet_1.address)], deploy.address)

        // readResult.result.expectOk();
    }
});