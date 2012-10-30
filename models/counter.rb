=begin
class Counter
  include Mongoid::Document
  
  field :count, :type => Integer
  field :cron, :type => Integer

  @queue = :counter

  def self.increment
    c = first || new({:count => 0})
    c.inc(:count, 1)
    c.save
    c.count
  end
  
  def self.increment_cron
    c = first || new({:cron => 0})
    c.inc(:cron, 1)
    c.save
    c.count
  end
  
  def self.cron
    c = first || new({:cron => 0})
    c.cron
  end

  def self.count
    c = first || new({:count => 0})
    c.count
  end

  def self.perform
    increment_cron
  end

end
=end