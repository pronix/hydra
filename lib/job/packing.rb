=begin rdoc
Упаковка файлов
=end
module Job
  module Packing
    def process_packing
      @_tmp_packed_path = File.join(task_path, 'tmp_packed_path')
      FileUtils.mkdir_p(@_tmp_packed_path)
      FileUtils.mkdir_p(packed_path)

      # Добавляем обложки в архив
      add_covers_to_arhive? && task_covers.each { |x|
        `cp '#{x.cover.attachment.path}' '#{File.join(@_tmp_packed_path,x.cover.attachment.original_filename )}'`
      }

      # Добавляем файлы в архив
      attachment_files.each { |x|
        `cp '#{x.attachment.path}' '#{File.join(@_tmp_packed_path,x.attachment.original_filename )}'`
      }

      # Добавляем скрин листы в архивu
      screen_list? && add_screens_to_arhive? && !list_screens.blank? &&
        list_screens.each { |x|
        `cp '#{x.screen.attachment.path}' '#{File.join(@_tmp_packed_path,x.screen.attachment.original_filename)}'` }



      @_out_file = Dir.glob(unpacked_path + "**/**").map { |x| x }.first
      @_out_file = [(@_out_file.blank? ? "arhive" :
                     (File.basename(@_out_file, File.extname(@_out_file)))), 'rar' ].join('.')
      @_out_file = File.join(packed_path, @_out_file)


      @_files =  [
                  Dir.glob(unpacked_path + "**/**").map { |x| x },
                  Dir.glob(@_tmp_packed_path + "**/**").map { |x| x }
                 ].flatten


      command = %(rar a -m0 -inul -ep )
      command << " -v#{part_size.to_i.megabyte/1000} " unless part_size.blank?
      command << " -p#{password_arhive.to_s} " unless password_arhive.blank?
      command << %( '#{@_out_file}' #{ @_files.map{ |x| "'#{x}'" }.join(' ') } )
      log command, :debug
      output = `#{command}`


      # Переименовываем архив если включено
      if rename? && !that_rename.blank? && that_rename[Common::ThatRename::ARCHIVE] &&
          !macro_renaming.blank?

        Dir.glob(packed_path + "**/**").each do |_file|
          _dir  = File.dirname(_file)
          _ext  = File.extname(_file)
          _name = File.basename(_file, File.extname(_file))
          _part = _name[/\.part\d+/]

          @new_file_name = macro_renaming.
            gsub(/\[file_name\]/,(!rename_file_name.blank? ? rename_file_name : _name) ).
            gsub(/\[part_number\]/, _part.to_s).
            gsub(/\[ext\]/,_ext).
            gsub(/\[text\]/, (!rename_text.blank? ? rename_text : '' )).
            gsub(/^\.|\.$/, '').gsub(/\.\./,'.')


          @new_file_name = File.join(File.dirname(_file), @new_file_name)

          command = "mv '#{_file}' '#{@new_file_name}'"
          log command, :debug
        `#{command}`
        end
      end

      # Удаляем временные файлы
      FileUtils.rm_rf(@_tmp_packed_path)
      job_completion!

    rescue => ex
      erroneous!(ex.message)
    end

  end
end
