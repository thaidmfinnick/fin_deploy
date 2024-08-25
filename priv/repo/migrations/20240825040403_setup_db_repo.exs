defmodule FinDeploy.Repo.Migrations.SetupDbRepo do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id,            :uuid,    primary_key: true
      add :full_name,     :string
      add :description,   :string
      add :email,         :string
      add :fb_id,         :string,  size: 32, default: nil
      add :access_token,  :string
      add :password_hash, :string
      add :phone_number,  :string
      add :locale,        :string
      add :timezone,      :string
      add :avatar_url,    :string

      timestamps()
    end
  end
end
