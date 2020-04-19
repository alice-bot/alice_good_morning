defmodule Alice.Handlers.GoodMorningLanguages do
  @moduledoc """
  This handler will allow Alice to say good morning to people in different languages.

  It does so only once each morning.
  """
  use Alice.Router
  alias Alice.Conn
  require Logger

  @good_mornings [
    %{text: "Good morning", regex: "good morning"},
    %{language: "Albanian", text: "Mirëmëngjes", regex: "Mirëmëngjes"},
    %{language: "Bascue", text: "Egun on", regex: "Egun on"},
    %{
      language: "Belarusian",
      text: "Добрай раніцы (Dobray ranici)",
      regex: "Добрай раніцы|Dobray ranici"
    },
    %{language: "Bosnian", text: "Dobro jutro", regex: "Dobro jutro"},
    %{language: "Bulgarian", text: "Добро утро (Dobro utro)", regex: "Добро утро|Dobro utro"},
    %{language: "Catalan", text: "Bon dia", regex: "Bon dia"},
    %{language: "Croatian", text: "Dobro jutro", regex: "Dobro jutro"},
    %{language: "Czech", text: "Dobré ráno", regex: "Dobré ráno"},
    %{language: "Danish", text: "Godmorgen", regex: "Godmorgen"},
    %{language: "Dutch", text: "Goedemorgen", regex: "Goedemorgen"},
    %{language: "Estonian", text: "Tere hommikust", regex: "Tere hommikust"},
    %{language: "Finnish", text: "Huomenta", regex: "Huomenta"},
    %{language: "French", text: "Bonjour", regex: "Bonjour"},
    %{language: "Galician", text: "Bos días", regex: "Bos días"},
    %{language: "German", text: "Guten Morgen", regex: "Guten Morgen"},
    %{language: "Greek", text: "Καλημέρα (Kaliméra)", regex: "Καλημέρα|Kaliméra"},
    %{language: "Hungarian", text: "Jó reggelt", regex: "Jó reggelt"},
    %{language: "Icelandic", text: "Góðan dag", regex: "Góðan dag"},
    %{language: "Italian", text: "Buongiorno", regex: "Buongiorno"},
    %{language: "Latvian", text: "Labrīt", regex: "Labrīt"},
    %{language: "Lithuanian", text: "Labas rytas", regex: "Labas rytas"},
    %{language: "Macedonian", text: "Добро утро (Dobro utro)", regex: "Добро утро|Dobro utro"},
    %{language: "Maltese", text: "Bongu", regex: "Bongu"},
    %{language: "Norwegian", text: "God morgen", regex: "God morgen"},
    %{language: "Polish", text: "Dzień dobry", regex: "Dzień dobry"},
    %{language: "Portuguese", text: "Bom dia", regex: "Bom dia"},
    %{language: "Romanian", text: "Bună dimineața", regex: "Bună dimineața"},
    %{language: "Russian", text: "Доброе утро (Dobro utro)", regex: "Доброе утро|Dobro utro"},
    %{language: "Serbian", text: "Добро јутро (Dobro utro)", regex: "Добро јутро|Dobro utro"},
    %{language: "Spanish", text: "Buenos días", regex: "Buenos días"},
    %{language: "Swedish", text: "God morgon", regex: "God morgon"},
    %{language: "Ukrainian", text: "Добрий ранок (Dobre rano)", regex: "Добрий ранок|Dobre rano"},
    %{language: "Welsh", text: "Bore da", regex: "Bore da"},
    %{language: "Yiddish", text: "אַ גוטנ מאָרג (Gut margn)", regex: "אַ גוטנ מאָרג|Gut margn"},
    %{language: "Afrikaans", text: "Goeie more", regex: "Goeie more"},
    %{language: "Swahili", text: "za asubuhi", regex: "za asubuhi"},
    %{language: "Zulu", text: "Sawubona", regex: "Sawubona"},
    %{
      language: "Armenian",
      text: "Շնորհակալություն (Chnorakaloutioun)",
      regex: "Շնորհակալություն|Chnorakaloutioun"
    },
    %{language: "Cantonese", text: "早晨 (Jóusàhn)", regex: "早晨|Jóusàhn"},
    %{language: "Hindi", text: "सुप्रभात (Namaste)", regex: "सुप्रभात|Namaste"},
    %{
      language: "Japanese",
      text: "おはようございます (Ohayōgozaimasu)",
      regex: "おはようございます|Ohayōgozaimasu"
    },
    %{language: "Korean", text: "(annyeong hashimnikka)", regex: "annyeong hashimnikka"},
    %{language: "Malay", text: "Selamat Pagi", regex: "Selamat Pagi"},
    %{language: "Mandarin", text: "早上好 (Zǎoshang hǎo)", regex: "早上好|Zǎoshang hǎo"},
    %{language: "Mongolian", text: "Өглөөний мэнд", regex: "Өглөөний мэнд"},
    %{language: "Tamil", text: "காலை வணக்கம் (Kālai vaṇakkam)", regex: "காலை வணக்கம்|Kālai vaṇakkam"},
    %{
      language: "Thai",
      text: "สวัสดี ครับ/ค่ะ (Sawùt dee krúp/kâ)",
      regex: "สวัสดี ครับ/ค่ะ|Sawùt dee krúp/kâ"
    },
    %{language: "Vietnamese", text: "Chào buổi sáng", regex: "Chào buổi sáng"},
    %{language: "Arabic", text: "صباح الخير (Sabah alkhyr)", regex: "صباح الخير|Sabah alkhyr"},
    %{language: "Farsi", text: "Salam", regex: "Salam"},
    %{language: "Turkish", text: "Günaydın", regex: "Günaydın"}
  ]

  @good_morning_languages @good_mornings |> Enum.map(& &1.regex) |> Enum.join("|")

  route ~r/\A#{@good_morning_languages}\z/i, :good_morning
  command ~r/> (#{@good_morning_languages})\z/i, :direct_good_morning
  command ~r/> (good morning|morning) language\z/i, :good_morning_language

  @doc """
  `Good Morning`
  `おはようございます`
  `Bonjour`
  Alice will respond back with a good morning in a random language
  """
  def direct_good_morning(conn) do
    with {timestamp, _} <- Integer.parse(Conn.timestamp(conn)),
         adjusted_time <- timestamp + Conn.tz_offset(conn),
         {:ok, datetime} <- DateTime.from_unix(adjusted_time),
         true <- morning?(datetime) do
      @good_mornings
      |> Enum.random()
      |> format_message()
      |> reply(conn)
    else
      false ->
        reply(conn, "#{Conn.at_reply_user(conn)} you silly, It's not morning anymore!")

      _ ->
        conn
    end
  end

  @doc """
  `good morning`
  `bom dia`
  `buenos días`
  `おはようございます`

  Say good morning to Alice in many different languages and she will respond
  with a "good morning" in a random language.
  """
  def good_morning(conn) do
    with {timestamp, _} <- Integer.parse(Conn.timestamp(conn)),
         adjusted_time <- timestamp + Conn.tz_offset(conn),
         {:ok, datetime} <- DateTime.from_unix(adjusted_time),
         true <- morning?(datetime),
         today <- DateTime.to_date(DateTime.utc_now()),
         :gt <- Date.compare(today, last_good_morning(conn)) do
      good_morning = Enum.random(@good_mornings)

      good_morning
      |> format_message()
      |> reply(conn)

      update_last_good_morning(conn, good_morning)
    else
      false ->
        Logger.info("#{__MODULE__} It's not morning anymore")
        conn

      _ ->
        Logger.info("#{__MODULE__} We already said good morning on #{last_good_morning(conn)}")
        conn
    end
  end

  @doc """
  `morning language`

  Returns the language of the last good morning alice said
  """
  def good_morning_language(conn) do
    conn
    |> get_state(:last_good_morning_language)
    |> format_message()
    |> reply(conn)
  end

  defp update_last_good_morning(conn, %{language: language}) do
    date = DateTime.to_date(DateTime.utc_now())

    conn
    |> put_state(:last_good_morning, date)
    |> put_state(:last_good_morning_language, language)
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

  defp format_message(%{text: text}) do
    "#{text}!"
  end

  defp format_message(language) do
    "Today's good morning was in #{language}"
  end

  defp morning?(%DateTime{} = datetime) do
    datetime.hour < 12
  end
end
