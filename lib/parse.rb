require 'launchy'
require 'date'
# require 'yaml'
require 'erb'
require_relative 'report1'
require_relative 'report2'

class Parse
  # @@config = YAML.load_file('config.yaml')
  OUTPUT_HTML = 'tmp/report.html'.freeze
  OUTPUT_GRAPH = 'tmp/graphviz.txt'.freeze

  def start
    @id = "293447V2"
    load_lookup
    load_blocks

    html = Report1.new(@blocks).render
    File.write(OUTPUT_HTML, html)
    # show_html

    graph = Report2.new(@blocks).render
    File.write(OUTPUT_GRAPH, graph)
  end

  def load_lookup
    @lookup = load_lines("officialwants").map{|x| tryParse(x)}.compact.to_h
  end

  def load_blocks
    lines = load_lines("results-official")
    lines = extract_section(lines,  "TRADE LOOPS", "ITEM SUMMARY")
    @blocks = []
    block = []
    for line in lines
      if line.strip == ""
        @blocks << block unless block == []
        block = []
      else
        block.insert(0, parse_item(line))
      end
    end
  end

  def parse_item(line)
    sides = line.split(" receives ").map do |x|
      /^\(([^)]+)\) (\d+)/.match(x).captures
    end
    e = Entry.new
    e.receiver, e.receiver_item = format_side(sides[0])
    e.sender, e.sender_item     = format_side(sides[1])
    return e
  end

  def format_side(side)
    return side[0], @lookup[side[1]].to_s
  end

  def load_lines(tag)
    filename = "tmp/#{@id}-#{tag}.txt"
    return File.readlines(filename)
  end

  def extract_section(lines, from, to)
    a = lines.find_index{|x|x.start_with? from}
    b = lines.find_index{|x|x.start_with? to}
    return lines[a+1..b-1]
  end

  def regex_from(pattern)
    Regexp.new(pattern, Regexp::IGNORECASE)
  end

  def tryParse(line)
    if m = /(.*) ==> (.*) "([^"]+)"/.match(line)
      k,_,v = m.captures
      return [k,v]
    else
      return nil
    end
  end

  def show_html
    Launchy.open(OUTPUT_HTML)
  end
end

class Entry
  attr_accessor :receiver
  attr_accessor :receiver_item
  attr_accessor :sender
  attr_accessor :sender_item
end
