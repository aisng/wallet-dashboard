class Evm::Constants
  METHODS = {
    get_balance: 'eth_getBalance',
    get_transaction_count: 'eth_getTransactionCount',
    get_block_number: 'eth_blockNumber',
    get_block_by_number: 'eth_getBlockByNumber'
  }.freeze
end
