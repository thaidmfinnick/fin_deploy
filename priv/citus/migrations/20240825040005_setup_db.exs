defmodule FinDeploy.Repo.Citus.Migrations.SetupDb do
  use Ecto.Migration

  def change do
    Ecto.Migration.execute("SET citus.shard_count = 4;")
    create table(:workspaces) do
      add :name, :string
      add :owner_id, :uuid, null: false
      add :settings, :map

      timestamps()
    end

    create table(:channels) do
      add :workspace_id, :bigint, null: false
      add :name, :string
      add :settings, :map
      add :topic, :string
      add :is_private, :boolean, default: false

      timestamps()
    end

    create table(:channel_members) do
      add :user_id, :uuid, null: false
      add :channel_id, :integer, null: false
      add :workspace_id, :bigint, null: false

      timestamps()
    end

    create table(:channel_threads, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :channel_id, :integer, null: false
      add :workspace_id, :bigint, null: false

      timestamps()
    end

    create table(:channel_thread_messages, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :channel_thread_id, :uuid
      add :workspace_id, :bigint, null: false
      add :direct_message_id, :uuid
      add :user_id, :uuid, null: false
      add :message, :text
      add :attachments, {:array, :map}, default: []

      timestamps()
    end

    create table(:workspace_contents, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :content_id, :string
      add :workspace_id, :bigint, null: false
      add :name, :string
      add :path, :string
      add :image_data, :map
      add :path_thumbnail, :string

      timestamps()
    end

    execute "ALTER TABLE channels DROP CONSTRAINT channels_pkey"
    execute "ALTER TABLE channels ADD PRIMARY KEY (workspace_id, id)"

    execute "ALTER TABLE channel_members DROP CONSTRAINT channel_members_pkey"
    execute "ALTER TABLE channel_members ADD PRIMARY KEY (workspace_id, id)"

    execute "ALTER TABLE channel_threads DROP CONSTRAINT channel_threads_pkey"
    execute "ALTER TABLE channel_threads ADD PRIMARY KEY (workspace_id, id)"

    execute "ALTER TABLE channel_thread_messages DROP CONSTRAINT channel_thread_messages_pkey"
    execute "ALTER TABLE channel_thread_messages ADD PRIMARY KEY (workspace_id, id)"

    execute "ALTER TABLE workspace_contents DROP CONSTRAINT workspace_contents_pkey"
    execute "ALTER TABLE workspace_contents ADD PRIMARY KEY (workspace_id, id)"

    execute "SELECT create_distributed_table('workspaces', 'id');"
    execute "SELECT create_distributed_table('channels', 'workspace_id', colocate_with => 'workspaces');"
    execute "SELECT create_distributed_table('channel_members', 'workspace_id', colocate_with => 'workspaces');"
    execute "SELECT create_distributed_table('channel_threads', 'workspace_id', colocate_with => 'workspaces');"
    execute "SELECT create_distributed_table('channel_thread_messages', 'workspace_id', colocate_with => 'workspaces');"
    execute "SELECT create_distributed_table('workspace_contents', 'workspace_id', colocate_with => 'workspaces');"
  end
end
