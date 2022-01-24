require 'erb'

class Report2
  def initialize(blocks)
    @blocks = blocks
    @creation_date = Time.now
  end

  def render
    ERB.new(HTML_TEMPLATE).result(binding)
  end

  HTML_TEMPLATE = %(
digraph G {

<% for @items,@index in @blocks.each_with_index %>
<% for @x in @items %>
<% @sid = @index.to_s + "_" + @x.sender %>
<% @rid = @index.to_s + "_" + @x.receiver %>

"<%= @sid %>" -> "<%= @rid %>" [label="<%= @x.sender_item %>"]
"<%= @sid %>" [label="<%= @x.sender %>"]
"<%= @rid %>" [label="<%= @x.receiver %>"]
<% end %>
<% end %>

}
).freeze
end

  # <%= "#{@x.sender} -> #{@x.receiver} [label="#{@x.sender_item}"] %>
