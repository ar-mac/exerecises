class BankEvent

  attr_reader :logfile
  def initialize
    @logfile = []
  end

  def new_transaction(type = :civil)
    @logfile.push ["---#{type} transaction---"]
  end

  def run(object)
    save object.message
    puts object.message
  end

  def show(message)
    save message
    puts message
  end

  def save(message)
    @logfile.last.push message
  end

  def show_logs
    logfile.each do |transaction|
      puts transaction
    end
  end
end
