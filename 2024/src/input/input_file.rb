# frozen_string_literal: true

class InputFile
  def initialize(file_path)
    @file_path = file_path
  end

  def each_line
    File.foreach(@file_path) {|l| yield l.chomp}
  end
end
