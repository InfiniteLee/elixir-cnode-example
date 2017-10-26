defmodule Complex do
  def foo(x), do:
    call_cnode {:foo, x}
  def bar(y), do:
    call_cnode {:bar, y}

  def register() do
    Process.register(self(), :complex)
    handle_responses()
    :ok
  end

  def double(val) do
    IO.inspect val
    val*2
  end

  defp call_cnode(msg) do
    {:ok, hostname} = :inet.gethostname
    send {:any, List.to_atom('c1@' ++ hostname)}, {:call, self(), msg}
    handle_response()
  end

  defp handle_response() do
    receive do
      {:cnode, msg} ->
        IO.inspect msg
        handle_response()
    after
      2_000 -> :timeout
    end
  end

  defp handle_responses() do
    receive do
      {:cnode, msg} ->
        IO.inspect msg
    end
    handle_responses()
  end

end
