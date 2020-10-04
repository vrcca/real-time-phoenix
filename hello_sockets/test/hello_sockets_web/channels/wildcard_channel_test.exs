defmodule HelloSocketsWeb.WildcardChannelTest do
  use HelloSocketsWeb.ChannelCase
  alias HelloSocketsWeb.UserSocket

  setup do
    %{socket: socket(UserSocket, nil, %{})}
  end

  describe "join/3 success" do
    test "ok when numbers in the format a:b where b = 2a", %{socket: socket} do
      assert {:ok, _, %Phoenix.Socket{}} = subscribe_and_join(socket, "wild:2:4", %{})
      assert {:ok, _, %Phoenix.Socket{}} = subscribe_and_join(socket, "wild:100:200", %{})
    end
  end

  describe "join/3 error" do
    test "error when b is not exactly with a", %{socket: socket} do
      assert {:error, %{}} == subscribe_and_join(socket, "wild:1:3", %{})
    end

    test "error when 3 numbers are provided", %{socket: socket} do
      assert {:error, %{}} == subscribe_and_join(socket, "wild:1:2:4", %{})
    end
  end

  describe "join/3 error causing crash" do
    test "error with an invalid format topic", %{socket: socket} do
      assert {:error, %{}} == subscribe_and_join(socket, "wild:invalid", %{})
    end
  end

  describe "handle_in ping" do
    setup %{socket: socket} do
      assert {:ok, _, channel} = subscribe_and_join(socket, "wild:2:4", %{})
      %{channel: channel}
    end

    test "a pong response is provided", %{channel: channel} do
      ref = push(channel, "ping", %{})
      response = %{ping: "pong"}
      assert_reply ref, :ok, ^response
    end
  end
end
