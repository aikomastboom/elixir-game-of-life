defmodule GameOfLife.Components do
  use Phoenix.Component

  attr :world, :list, default: []
  slot :alive
  slot :dead

  def world(assigns) do
    ~H"""
    <table>
      <%= for r <- @world do %>
        <tr height="32">
          <%= for c <- r do %>
            <%= if c == 1 do %>
              <td width="32" class="bg-blue-500 align-middle text-center">
                <b>
                  <%= render_slot(@alive) || "@" %>
                </b>
              </td>
            <% else %>
              <td width="32" class="bg-red-500 align-middle text-center">
                <b>
                  <%= render_slot(@dead) || "\u00B7" %>
                </b>
              </td>
            <% end %>
          <% end %>
        </tr>
      <% end %>
    </table>
    """
  end

  attr :title, :string, required: true

  def heading(assigns) do
    ~H"""
    <h1 class="text-2xl mb-2"><%= @title %></h1>
    """
  end

  attr :name, :string, required: true

  def greet(assigns) do
    ~H"""
    <p>Hello <%= @name %></p>
    """
  end

  slot(:inner_block, required: true)

  def button(assigns) do
    ~H"""
    <button>
      <%= render_slot(@inner_block) %>
    </button>
    """
  end
end
