defmodule Alice.Handlers.GoodMorning do
  @moduledoc """
  This handler will allow Alice to say good morning to people.

  It does so only once each morning.
  """
  use Alice.Router
  require Logger

  @good_morning_regex ~r/good morning/i

  route(@good_morning_regex, :good_morning)
  command(@good_morning_regex, :good_morning_with_check)

  @good_mornings [
    "Good morning!",
    "Good morning to you too!"
  ]

  @doc """
  Say good morning to Alice in many different languages and she will respond
  with a "good morning" in a different language.
  """
  def good_morning_with_check(conn) do
    with today <- DateTime.to_date(DateTime.utc_now()),
         :gt <- Date.compare(today, last_good_morning(conn)) do
      @good_mornings
      |> Enum.random()
      |> reply(conn)
      |> update_last_good_morning()
    else
      false -> reply(conn, "It's not morning silly...")
      _ -> conn
    end
  end

  def good_morning(conn) do
    with today <- DateTime.to_date(DateTime.utc_now()),
         :gt <- Date.compare(today, last_good_morning(conn)) do
      @good_mornings
      |> Enum.random()
      |> reply(conn)
      |> update_last_good_morning()
    else
      _ ->
        Logger.info("We already said good morning on #{last_good_morning(conn)}")
        conn
    end
  end

  defp update_last_good_morning(conn) do
    date = DateTime.to_date(DateTime.utc_now())
    put_state(conn, :last_good_morning, date)
  end

  defp last_good_morning(conn) do
    default =
      DateTime.utc_now()
      |> DateTime.to_date()
      |> Date.add(-1)
      |> to_string()

    conn
    |> get_state(:last_good_morning, default)
    |> Date.from_iso8601!()
  end
end
