=begin rdoc
    Переименовываем распакованные файлы.
=end
module Job
  module Rename
    def process_renaming
      # Если включены переименоывание, распаковка файлов и если переимновыаем файлы
      if  rename? && extracting_files? && that_rename[Common::ThatRename::FILE] && !macro_renaming.blank?
        @unpacked_files = Dir.glob(unpacked_path + "**/**")

        @unpacked_files.each_with_index do |unpacked_file, i|

          file_name_witout_ext = File.basename(unpacked_file, File.extname(unpacked_file))
          new_file = macro_renaming.
            gsub(/\[file_name\]/, (!rename_file_name.blank? ?
                                   (@unpacked_files.size > 1 ? "#{rename_file_name}_#{i}" : rename_file_name) :
                                   (@unpacked_files.size > 1 ? "#{file_name_witout_ext}_#{i}" : file_name_witout_ext) )).
            gsub(/\[part_number\]/,'').
            gsub(/\[ext\]/,File.extname(unpacked_file)).
            gsub(/\[text\]/,(!rename_text.blank? ? rename_text : '' )).
            gsub(/^\.|\.$/, '').gsub(/\.\./,'.')
          new_file = File.join(File.dirname(unpacked_file), new_file)
          command = "mv '#{unpacked_file}' '#{new_file}'"

          `#{command}`

        end

      end
      job_completion!("Rename file: #{@unpacked_files.size}")
    rescue => ex
      erroneous!(ex.message)
    end
  end
end
# Список макросов, относительно построения названия файла:
# [file_name] – название файла
# [text] – произвольный текст
# [part_number] – номер части мнотомного архива
# [ext] – расширение файла (взято с примера ниже)
# Больше пока не нужно, это нам пока хватит с головой. Меняться список не будет.
# Построение названия
# [file_name].[text].[part_number].[ext]
# Каждый макрос разделяется точкой, макросы [text] и [part_number] можно менять местами. Больше никаких вариантов.
# Если к примеру переименовываем файл, новое название – 02.02.2010-photos, добавляем в поле Text – google.com,
# размер архива из Х частей, [ext]= rar, получаем название файла (архива)
# 02.02.2010-photos. google.com. part_x.rar
