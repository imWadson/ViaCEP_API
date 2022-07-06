defmodule MyApp.ViaCep.Client do
  use Tesla

  alias Tesla.Env

  # @base_url "https://viacep.com.br/ws/"

  plug Tesla.Middleware.BaseUrl, "https://viacep.com.br/ws"
  plug Tesla.Middleware.Headers, [{"User-Agent", "ignite_github"}]
  plug Tesla.Middleware.JSON

  def get_cep(cep) do
    "/#{cep}/json/"
    |> get()
    |> handle_get()
  end

  defp handle_get({:ok, %Env{status: 200, body: %{"erro" => "true"}}}),
    do: {:error, "CEP not found!"}

  defp handle_get({:ok, %Env{status: 200, body: body}}), do: {:ok, body}

  defp handle_get({:ok, %Env{status: 400}}), do: {:error, "Invalid CEP!"}

  defp handle_get({:error, _reason} = error), do: error
end
