ExUnit.start()

{:ok, _} = Application.ensure_all_started(:ex_machina)

Application.ensure_all_started(:ex_process)
Application.ensure_all_started(:magic_home)
