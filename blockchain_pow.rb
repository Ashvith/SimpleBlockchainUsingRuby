require "digest"
require "pp"

class Block
  attr_reader :index, :data, :previous_hash, :nonce, :hash

  def initialize( index, data, previous_hash )
    @index = index
    @timestamp = Time.now
    @data = data
    @previous_hash = previous_hash
    @nonce, @hash = compute_hash_with_proof_of_work
  end
  
  def compute_hash_with_proof_of_work( difficulty="0000" )
    nonce = 0
    loop do
      hash = calc_hash_with_nonce( nonce )
      print("\nHash: #{hash} Nonce: #{nonce}")
      if hash.start_with?( difficulty )
        print("\n\nFound it!! Checking for the next hash...\n")
        return [nonce, hash]
      else
        print("\nNot found, trying again...")
        nonce += 1
      end
    end
  end
  
  def calc_hash_with_nonce( nonce=0 )
    sha = Digest::SHA1.new
    sha.update(@index.to_s + @timestamp.to_s + @data + nonce.to_s + @previous_hash)
    sha.hexdigest
  end

  def self.first( data="Genesis" )
    Block.new( 0, data, "0" )
  end

  def self.next( previous, data="Transaction Data..." )
    Block.new( previous.index+1, data, previous.hash )
  end
end

################################################################
# TESTING THE BLOCKS
################################################################
b0 = Block.first( "Genesis" )
b1 = Block.next( b0, "Transaction Data......" )
b2 = Block.next( b1, "Transaction Data......" )
b3 = Block.next( b2, "More Transaction Data..." )

blockchain = [b0, b1, b2, b3]

pp blockchain
################################################################