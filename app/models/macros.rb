class Macros < ActiveRecord::Base
  belongs_to :logo, :class_name => UserFile
  validates_inclusion_of :font, :in => Common::Font.valid_options
  validates_inclusion_of :position_timestamp,
                         :in => Common::PositionTimestamp.valid_options,
                         :if => lambda{ |t| t.add_timestamp? }
  validates_inclusion_of :file_format, :in => Common::FileFormat.valid_options

end
