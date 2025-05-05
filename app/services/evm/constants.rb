class Evm::Constants
  METHOD_MAP = {
   'eth_getBalance' => { method: :balance, required_params: [:address] },
   'eth_getTransactionCount' => { method: :tx_count, required_params: [:address] },
   'eth_blockNumber' => { method: :block_number, required_params: [] },
   'eth_getBlockByNumber' => { method: :block_by_number, required_params: [:block_number] }
 }.freeze
end
