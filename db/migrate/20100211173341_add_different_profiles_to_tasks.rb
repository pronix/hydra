class AddDifferentProfilesToTasks < ActiveRecord::Migration
  def self.up
    # Создавать скрин лист
    add_column :tasks, :screen_list,   :boolean # создавать скрин лист
    add_column :tasks, :screen_list_macro_id, :integer # ссылка на макрос скрин лист

    # Зарука картинок на хотстинг изабражений
    add_column :tasks, :upload_images,          :boolean   # закачивать изображения
    add_column :tasks, :upload_images_profile_id, :integer # ссылка на профайл закачки

    # Зарука файлов на mediavalise
    add_column :tasks, :mediavalise,           :boolean  # закачивать файлы на mediavalise
    add_column :tasks, :mediavalise_profile_id, :integer # ссылка на профайл закачки

    # Создание архива
    add_column :tasks, :create_arhive,   :boolean  # создавать архив
    add_column :tasks, :password_arhive, :string   # пароль для архива
    add_column :tasks, :part_size,       :string   # размер тома архива

  end

  def self.down
    remove_column :tasks, :screen_list
    remove_column :tasks, :screen_list_macro_id
    remove_column :tasks, :upload_images
    remove_column :tasks, :upload_images_profile_id
    remove_column :tasks, :mediavalise
    remove_column :tasks, :mediavalise_profile_id

    remove_column :tasks, :create_arhive
    remove_column :tasks, :password_arhive
    remove_column :tasks, :part_size

  end
end
