defmodule ElephantCarpacchioWeb.CalculationLive do
  use ElephantCarpacchioWeb, :live_view

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <.header>Easy Self-Checkout</.header>

    <.form for={@form} phx-submit="calculate">
      <.input type="number" field={@form[:count]} label="How many items ?" value={nil} />
      <.input type="number" field={@form[:price]} label="Price per item ?" value={nil} />

      <.input type="select" field={@form[:state]} options={~w[California Nevada Texas Alabama Utah]}>
      </.input>

      <.button type="submit" class="mt-8">
        Checkout
      </.button>

      <p :if={assigns[:result]} class="mt-8">
        Your total is <%= @result %>
      </p>
    </.form>
    """
  end

  @impl Phoenix.LiveView
  def mount(params, _session, socket) do
    {:ok, socket |> assign(:form, to_form(%{}))}
  end

  @impl Phoenix.LiveView
  def handle_event("calculate", params, socket) do
    count = params |> Map.fetch!("count") |> String.to_integer()
    price_per_item = params |> Map.fetch!("price") |> String.to_integer()

    result =
      (count * price_per_item)
      |> apply_discount()
      |> apply_taxes(params["state"])

    {:noreply, socket |> assign(:result, result)}
  end

  defp apply_taxes(amount, state) do
    amount * tax_rate(state)
  end

  defp apply_discount(total) when total > 50_000, do: total * 0.85
  defp apply_discount(total) when total > 10_000, do: total * 0.90
  defp apply_discount(total) when total > 7_000, do: total * 0.93
  defp apply_discount(total) when total > 5_000, do: total * 0.95
  defp apply_discount(total) when total > 1_000, do: total * 0.97
  defp apply_discount(total), do: total

  defp tax_rate("California"), do: 1.0825
  defp tax_rate("Nevada"), do: 1.08
  defp tax_rate("Texas"), do: 1.0625
  defp tax_rate("Alabama"), do: 1.04
  defp tax_rate("Utah"), do: 1.0685
end
