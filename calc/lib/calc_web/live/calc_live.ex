defmodule CalcWeb.Calc do
  use CalcWeb, :live_view

  alias CalcWeb.CalcView

  def mount(_params, _session, socket) do
    {:ok, reset_assigns(socket)}
  end

  def render(assigns) do
    CalcView.render("index.html", assigns)
  end

  defp reset_assigns(socket) do
    assign(socket, %{
      display: '',
      value: 0
    })
  end

  # Digit clicks
  def handle_event("digit", digit, socket = %{assigns: %{reset_on_next_digit: true}}) do
    {:noreply, assign(socket, display: digit, reset_on_next_digit: false)}
  end

  def handle_event("digit", digit, socket) do
    IO.inspect(digit)
    {:noreply, assign(socket, display: "#{socket.assigns.display}#{digit["digit"]}")}
  end

  # Operator clicks (+,-,*,/)...
  # when there is no pending operator. Whatever is on the display becomes the current value.
  def handle_event("operator", operator, socket) do
    {:noreply, assign(socket, display: "#{socket.assigns.display}#{operator["operator"]}")}
  end

  def handle_event("solve", _solve, socket) do
    {result, _} = Code.eval_string(socket.assigns.display)
    {:noreply, assign(socket, display: "#{result}")}
  end

  def handle_event("reset", _, socket) do
    {:noreply, assign(socket, display: '', value: 0)}
  end
end
