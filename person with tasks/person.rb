class Task
  attr_reader :name, :completed
  alias_method :completed?, :completed

  def initialize(name, completed)
    @name = name
    @completed = completed
  end

  def to_s
    "#{name} - status: #{completed}"
  end
end

class Person
  attr_reader :tasks

  def initialize(tasks)
    @tasks = *tasks
  end

  def completed_tasks
    tasks.select { |task| task.completed? }
  end

end

tasks = []
3.times do |n|
  tasks << Task.new("task##{n}", true)
  tasks << Task.new("task##{n+3}", false)
end
person = Person.new(tasks)

puts person.completed_tasks