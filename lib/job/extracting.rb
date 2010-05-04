require 'open3'
class JobExtractingError < StandardError #:nodoc:
end

module Job
  module Extracting
    # ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    # Процессраспаковки файлов
    # ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    def process_of_unpacking
      @path = unpacked_path
      FileUtils.mkdir_p(@path)

      # Если есть файлы в архиве gzip or bzip2 распакуем их сначала
      Dir.glob(downloding_path + "**/**").each do |task_file|
        result = nil
        case IO.popen(%(file -b #{task_file})).readline
        when /^gzip/i
          command = %(gunzip -f #{task_file})
          Open3.popen3(command){ |gzip_in, gzip_out, gzip_err| result = gzip_err.gets; raise result unless result.blank? }
        when /^bzip2/i
          command = %(bunzip2 -f #{task_file})
          Open3.popen3(command){ |bzip2_in, bzip2_out, bzip2_err| result = bzip2_err.gets; raise result unless result.blank? }
        end
      end

      Dir.glob(downloding_path + "**/**").each do |task_file|
        result = nil
        case IO.popen(%(file -b #{task_file})).readline
        when /^zip/i
          command =  use_password? ? %(unzip -o -P #{password}  #{task_file} -d #{@path}/ ) :
            %(unzip -o  #{task_file} -d #{@path}/ )
          Open3.popen3(command){ |zip_in, zip_out, zip_err| result = zip_err.gets; raise result unless result.blank?  }
        when /^rar/i
          command = use_password? ? %(rar e -y -p#{password} -inul #{task_file}  #{@path}/) :
            %(rar e -y -inul #{task_file}  #{@path}/)
          Open3.popen3(command){ |rar_in, rar_out, rar_err| result = rar_err.gets; raise result unless result.blank?  }
        when /tar/i
          command = %(tar xf #{task_file} -C #{@path})
          Open3.popen3(command){ |tar_in, tar_out, tar_err| result = tar_err.gets; raise result unless result.blank?  }
        else
          # Определили что распоковать файл не сможем
          # но вдруг файл просто видео то копируем его
          type_file = nil
          Open3.popen3("file -i #{task_file}") {|i,o,e| type_file =  o.gets }
          if !type_file.blank? && Common::Video.mime_type.include?(type_file.split(':').last.scan(/[a-zA-Z0-9-]+\/[a-zA-Z0-9-]+/).first)
            system(%(cp #{task_file} #{@path}/))
          else
            raise JobExtractingError, "archive type is not defined or not supported"
          end
        end
      end

      job_completion!("Count files: #{Dir.glob(@path+ "**/**").size}")

    rescue JobExtractingError => ex
      raise erroneous!("#{ex.message}")
    rescue => ex
      erroneous!("Unknow error")
      Task.log ex.message, :error
      raise
    end

  end
end
