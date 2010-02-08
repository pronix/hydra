class CreateMacros < ActiveRecord::Migration
  def self.up
    create_table :macros do |t|
      t.string   :name
      t.integer  :user_id
      
      t.integer  :number_of_frames
      t.integer  :columns
      t.integer  :thumb_width 
      t.integer  :thumb_height
      t.integer  :thumb_quality  # 0-100
      
      t.boolean  :thumb_frame
      
      t.integer  :frame_size
      t.string   :frame_color
      t.boolean  :thumb_shadow
      t.string   :thumb_padding  # "2px 3px 3px 4px"
      
      # template
      t.string   :font
      t.integer  :font_size
      t.string   :font_color
      t.string   :template_background
      
      t.string   :header_text
      
      t.boolean  :add_timestamp
      t.string   :position_timestamp
      
      t.boolean  :add_logo
      t.string   :logo_id
      
      t.string   :file_format
      
      t.timestamps
    end
    add_index :macros, :user_id
  end

  def self.down
    drop_table :macros
  end
end
