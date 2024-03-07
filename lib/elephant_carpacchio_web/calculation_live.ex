defmodule ElephantCarpacchioWeb.CalculationLive do
  use ElephantCarpacchioWeb, :live_view

  def render(assigns) do
    ~H"""
      <h1>Sales Price Calculator</h1>
    """
  end

  def mount(params, _session, socket) do
    {:ok, socket}
  end
end
