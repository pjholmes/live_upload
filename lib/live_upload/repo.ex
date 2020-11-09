defmodule LiveUpload.Repo do
  use Ecto.Repo,
    otp_app: :live_upload,
    adapter: Ecto.Adapters.Postgres
end
