=begin
Code generation helper class.

(c) 2011, Nicholas Booker <NMBooker@gmail.com>
License: MIT

This is to help to produce code with good indentation.
=end

class CodeGen
  def initialize(out)
    @out = out
    @indent = '  '
    @indent_level = 0
  end

  def indent
    @indent_level += 1
  end

  def unindent
    @indent_level -= 1 unless @indent_level <= 0
  end

  def puts(str='')
    @out.puts((@indent * @indent_level) + str)
  end

  def block(start=nil, opts={})
    puts start unless start.nil?
    indent
    begin
      yield
    ensure
      unindent
      puts opts[:end] unless opts[:end].nil?
    end
  end
end

