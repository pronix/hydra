class Macros < ActiveRecord::Base
  belongs_to :logo, :class_name => "UserFile"
  validates_presence_of :name
  validates_inclusion_of :font, :in => Common::Font.valid_options
  validates_inclusion_of :position_timestamp,
                         :in => Common::PositionTimestamp.valid_options,
                         :if => lambda{ |t| t.add_timestamp? }
  validates_inclusion_of :file_format, :in => Common::FileFormat.valid_options
  validates_inclusion_of :thumb_quality, :in => 0..100, :allow_nil => true
  validates_presence_of :logo_id, :if => lambda{ |t| t.add_logo? }
  validates_presence_of :columns
  validates_presence_of :number_of_frames
  validates_presence_of :frame_size, :if => lambda{ |t| t.thumb_frame? }
end
