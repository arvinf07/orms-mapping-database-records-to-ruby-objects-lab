require 'pry'

class Student
  attr_accessor :id, :name, :grade
  
  # def initialize(name, grade, id = nil)
  #   @name = name
  #   @grade = grade
  #   @id = id
  # end  

  def self.new_from_db(row)
    stu = Student.new
    stu.id = row[0]
    stu.name = row[1]
    stu.grade = row[2]
    stu
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = "SELECT * FROM students"
    response = DB[:conn].execute(sql)
    response.map {|student| self.new_from_db(student)}
  end

  def self.all_students_in_grade_9
    self.all.select {|student| student.grade == "9"}
  end  

  def self.students_below_12th_grade
    self.all.select {|student| student.grade.to_i < 12}
  end  

  def self.first_X_students_in_grade_10(x)
    all = self.all.select {|student| student.grade.to_i == 10}
    all.slice(0, x)
  end  

  def self.first_student_in_grade_10
    self.all.select {|student| student.grade.to_i == 10}.first
  end  

  def self.all_students_in_grade_X(x)
    self.all.select {|student| student.grade.to_i == x}
  end  

  def self.find_by_name(name)
    sql = 
    "SELECT * FROM students
    WHERE name = ?"
    row = DB[:conn].execute(sql, name)
    self.new_from_db(row[0])
  end
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
