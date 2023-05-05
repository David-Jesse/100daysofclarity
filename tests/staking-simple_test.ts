
import { Clarinet, Tx, Chain, Account, Contract, types } from 'https://deno.land/x/clarinet@v1.5.4/index.ts';
import { assertEquals } from 'https://deno.land/std@0.170.0/testing/asserts.ts';

Clarinet.test({
    name: "Ensure that user can mint NFT & stake",
    async fn(chain: Chain, accounts: Map<string, Account>) {
        // arrange: set up the chain, state, and other required elements
        let deployer = accounts.get["deployer"]!;
        let wallet_1 = accounts.get["wallet_1"]!;

        // act: perform actions related to the current test
        let mintBlock = chain.mineBlock([
          Tx.contractCall("nft-simple", "mint", [], deployer.address())
        ]);

        console.log(mintBlock.receipts[0].events)

        chain.mineEmptyBlock(1)

        let stakeBlock = chain.mineBlock([
            Tx.contractCall("staking-simple", "stake-nft", [types.uint(1)], deployer.address())
        ])

        console.log(stakeBlock.receipts[0].events)
        stakeBlock.receipts[0].result.expectOk()

        // block.receipts[0].results.expectOk()
    },
});


Clarinet.test({
    name: "Get unclaimed balance after 5 blocks",
    async fn(chain: Chain, accounts: Map<string, Account>) {
        
        let deployer = accounts.get["deployer"]!;
        let wallet_1 = accounts.get["wallet_1"]!;

        // act: perform actions related to the current test
        let mintBlock = chain.mineBlock([
          Tx.contractCall("nft-simple", "mint", [], deployer.address)
        ]);

        console.log(mintBlock.receipts[0].events)

        chain.mineEmptyBlock(1)

        let stakeBlock = chain.mineBlock([
            Tx.contractCall("staking-simple", "stake-nft", [types.uint(1)], deployer.address)
        ]);

        // console.log(stakeBlock.receipts[0].events)

        chain.mineEmptyBlock(5)
        
        let claimBlock = chain.mineBlock([
            Tx.contractCall("simple-staking", "claim-reward", [types.uint(1)], deployer.address)
        ]);

        // const getUnclaimedBalance = chain.callReadOnlyFn("staking-simple", "get-unclaimed-balance", [], deployer.address);

        console.log(claimBlock.receipts[0])

        console.log(chain.getAssertMaps())
        assertEquals(chain.getAssertMaps().assets[".simple-ft.clarity-token"][deployer.address], 6)


        

        // // TODO
        // assertEquals("TODO", "a complete test");
    },
});
