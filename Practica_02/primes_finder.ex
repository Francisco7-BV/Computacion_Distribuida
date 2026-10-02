defmodule PrimesFinder do

  alias PrimesFinder.Server


  def experimentos(valores_n \\ [10_000, 20_000, 40_000]) do
    trabajadores = [1, 2, 4, 8, 16]

    IO.puts("Tiempos de ejecución expresados en milisegundos (ms)\n")

    # Construir e imprimir el encabezado de la tabla
    encabezado_workers = Enum.map_join(trabajadores, " | ", fn w -> String.pad_leading("#{w}", 6) end)
    IO.puts(String.pad_leading("N", 8) <> " | " <> encabezado_workers)


    longitud_linea = String.length(encabezado_workers)
    IO.puts(String.duplicate("-", 9) <> "+" <> String.duplicate("-", longitud_linea + 1))

    # Ejecutar para cada valor de N
    Enum.each(valores_n, fn n ->


      tiempos_fila = Enum.map(trabajadores, fn num_workers ->
        # :timer.tc: devuelve el tiempo en microsegundos
        {tiempo_micro, _resultado} = :timer.tc(fn -> Server.start(num_workers, n) end)

        # Convertimos a milisegundos
        tiempo_mili = tiempo_micro / 1000.0

        :erlang.float_to_binary(tiempo_mili, [decimals: 2])
        |> String.pad_leading(6)
      end)

      # Imprimir la fila correspondiente a este valor de N
      fila_str = Enum.join(tiempos_fila, " | ")
      n_str = String.pad_leading(Integer.to_string(n), 8)
      IO.puts("#{n_str} | #{fila_str}")
    end)

    IO.puts("\nExperimentos finalizados.")
  end
end
