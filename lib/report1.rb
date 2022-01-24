require 'erb'

class Report1
  def initialize(blocks)
    @blocks = blocks
    @creation_date = Time.now
  end

  def render
    ERB.new(HTML_TEMPLATE).result(binding)
  end

  HTML_TEMPLATE = %(
    <html>
    <head>
      <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    </head>
    <body style="font-family:Trebuchet MS;">
    <% for @items,@index in @blocks.each_with_index %>
    <h3>Loop #<%=@index+1%></h3>
    <p>
      <span><%= @items[-1].receiver %><span>
      <% for @x in @items %>
      <span>
        <b><%= @x.sender_item %></b>
        &gt;
        <%= @x.receiver %>
      <span>
      <% end %>
    <p>
    <% end %>
    </body></html>).freeze

    # <div>Created: <%= @creation_date %>.</div>
end
