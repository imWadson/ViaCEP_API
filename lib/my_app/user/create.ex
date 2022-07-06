defmodule MyApp.User.Create do
  alias MyApp.{Repo, User}
  alias MyApp.ViaCep.Client

  @type user_params :: %{
          first_name: String.t(),
          last_name: String.t(),
          cep: String.t(),
          email: String.t()
        }

  @spec call(user_params()) :: {:error, Ecto.Changeset.t() | map()} | {:ok, Ecto.Schema.t()}
  def call(params) do
    cep = Map.get(params, :cep)

    changeset = User.changeset(%User{}, params)

    with {:ok, %User{}} <- User.validate_insert(changeset),
         {:ok, %{"localidade" => city, "uf" => uf}} <- Client.get_cep(cep),
         params <- Map.merge(params, %{city: city, uf: uf}),
         changeset <- User.changeset(%User{}, params),
         {:ok, %User{}} = user <- Repo.insert(changeset) do
      user
    end
  end
end
