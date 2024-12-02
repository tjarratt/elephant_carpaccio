defmodule ElephantCarpacchioWeb.CalculationLive do
  use ElephantCarpacchioWeb, :live_view

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <.header>Super Easy Energy Transition Store</.header>

    <.form for={@form} phx-submit="calculate">
      <.input type="number" field={@form[:count]} label="How many items ?" value={nil} />
      <.input type="number" field={@form[:price]} label="Price per item ?" value={nil} />

      <.input type="select" field={@form[:country]} label="Country" options={["Portugal", "India", "United Kingdom", "United States", "France" ]} />

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
      |> apply_taxes(params["country"])

    {:noreply, socket |> assign(:result, result)}
  end

  defp apply_taxes(amount, country) do
    amount * tax_rate(country)
  end

  defp apply_discount(total) when total > 50_000, do: total * 0.85
  defp apply_discount(total) when total > 10_000, do: total * 0.90
  defp apply_discount(total) when total > 7_000, do: total * 0.93
  defp apply_discount(total) when total > 5_000, do: total * 0.95
  defp apply_discount(total) when total > 1_000, do: total * 0.97
  defp apply_discount(total), do: total

  defp tax_rate("France"), do: 1.1125
  defp tax_rate("Portugal"), do: 1.08
  defp tax_rate("United Kingdom"), do: 1.0625
  defp tax_rate("United States"), do: 1.04
  defp tax_rate("India"), do: 1.0685
end
