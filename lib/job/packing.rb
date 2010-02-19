=begin rdoc
Упаковка файлов
=end
module Job
  module Packing
    def process_packing
      job_completion!
    rescue => ex

      erroneous!(ex.message)
    end
    # @_out_file = File.join(packed_path, "arhive.rar")
    # @_files =  Dir.glob(unpacked_path + "**/**").map { |x| x }

    # command = %(rar a -inul -v5M -p123456 '#{@_out_file}' #{@_files.map{ |x| "''#{x}'"}.join(' ') })
    # output = `#{command}`
    # # Если в задаче указано переименование архива то нужно выполнить переименование архива
  end
end
