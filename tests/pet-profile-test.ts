import {
  Clarinet,
  Tx,
  Chain,
  Account,
  types
} from 'https://deno.land/x/clarinet@v1.0.0/index.ts';
import { assertEquals } from 'https://deno.land/std@0.90.0/testing/asserts.ts';

Clarinet.test({
  name: "Can create new pet profile",
  async fn(chain: Chain, accounts: Map<string, Account>) {
    const wallet_1 = accounts.get("wallet_1")!;
    
    let block = chain.mineBlock([
      Tx.contractCall("pet-profile", "create-profile", [
        types.utf8("Max"),
        types.utf8("Dog"),
        types.uint(1625097600), // July 1, 2021
        types.utf8("Friendly golden retriever who loves to play fetch")
      ], wallet_1.address)
    ]);
    
    assertEquals(block.receipts.length, 1);
    assertEquals(block.height, 2);
    
    const result = block.receipts[0].result;
    result.expectOk().expectUint(1);
  },
});
