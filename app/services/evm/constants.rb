class Evm::Constants
  RPC_METHOD_MAP = {
   'eth_getBalance' => :balance,
   'eth_getTransactionCount' => :tx_count,
   'eth_blockNumber' => :block_number,
   'eth_getBlockByNumber' => :block_by_number
 }.freeze
end
