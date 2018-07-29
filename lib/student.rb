require_relative "../config/environment.rb"
require 'pry'
class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  attr_reader :id
  attr_accessor :name, :grade
  def initialize(name = "", grade = "", id = nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    );
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
    DROP TABLE IF EXISTS students;
    SQL

    DB[:conn].execute(sql)
  end

  def update
    sql = <<-SQL
    UPDATE students
    SET name = ?, grade = ?
    WHERE id = ?
    SQL

    DB[:conn].execute(sql,self.name, self.grade, self.id)
  end

  def save
    if self.id
      self.update
    else
      sql = <<-SQL
      INSERT INTO students (name, grade) VALUES (?,?);
      SQL

      DB[:conn].execute(sql, self.name, self.grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students;")[0][0]
    end
  end

  def self.create(name, grade)
    new_student = Student.new(name,grade)
    new_student.save
  end

  def self.new_from_db(row)
    new_student = Student.new(row[1],row[2],row[0])
    #new_student.id = row[0]
    #new_student.name = row[1]
    #new_student.grade = row[2]
    #new_student
    # sql = <<-SQL
    # SELECT name, grade FROM students
    # WHERE id = ?
    # SQL
    #
    # new_student = DB[:conn].execute(sql, row)
    #
    #
    #
    # DB[:conn].execute(SOMETHING IN HERE)
  end

  def self.find_by_name(name)
    sql = <<-SQL
    SELECT * FROM students
    WHERE name = ?
    SQL

    row = DB[:conn].execute(sql, name)[0]
    
    self.new_from_db(row)
  end

end
