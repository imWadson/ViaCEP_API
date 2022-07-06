defmodule MyApp.User.Create do
  alias MyApp.{Repo, User}

  @type user_params :: %{
          first_name: String.t(),
          last_name: String.t(),
          cep: String.t(),
          email: String.t()
        }

  @spec call(user_params()) :: {:error, Ecto.Changeset.t()} | {:ok, Ecto.Schema.t()}

  def call(params) do
    %User{}
    |> User.changeset(params)
    |> Repo.insert()
  end
end
