defmodule Appsignal.Error.BackendTest do
  use ExUnit.Case, async: true
  import ExUnit.CaptureIO
  alias Appsignal.{Error.Backend, Span, WrappedNif, Test}

  setup do
    WrappedNif.start_link()
    Test.Tracer.start_link()
    :ok
  end

  test "is added as a Logger backend" do
    assert {:error, :already_present} = Logger.add_backend(Backend)
  end

  describe "when an exception is raised" do
    test "creates a span" do
      pid = spawn(fn -> raise "Exception" end)

      :timer.sleep(100)

      assert {:ok, [{"", nil, ^pid}]} = Test.Tracer.get(:create_span)
    end
  end
end
