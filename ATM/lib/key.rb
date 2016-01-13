class Key

  attr_reader :security_num
  def initialize(security_num)
    @security_num = Random.new(security_num)
  end
end
